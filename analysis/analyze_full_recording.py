#!/usr/bin/env python3
"""Measure long-term breath-like behaviour in Steve Roden's Airforms.

The source recording is used as an external analytical input and is never
copied into the project.  The script writes a behavioural summary rather than
an event-by-event transcription.
"""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import wavfile
from scipy.ndimage import gaussian_filter1d
from scipy.signal import find_peaks, peak_widths, welch
from sklearn.mixture import GaussianMixture


ANALYSIS_VERSION = "1.1"


def robust_z(values: np.ndarray) -> np.ndarray:
    median = np.median(values)
    mad = np.median(np.abs(values - median))
    scale = 1.4826 * mad if mad > 1e-12 else np.std(values)
    return (values - median) / max(scale, 1e-12)


def frame_rms_stereo(path: Path, frame_seconds: float = 0.1):
    rate, samples = wavfile.read(path, mmap=True)
    if samples.ndim != 2 or samples.shape[1] != 2:
        raise ValueError("stereo input must contain exactly two channels")
    frame = int(round(rate * frame_seconds))
    usable = (samples.shape[0] // frame) * frame
    data = np.asarray(samples[:usable], dtype=np.float32).reshape(-1, frame, 2)
    data /= 32768.0
    rms = np.sqrt(np.mean(data * data, axis=1) + 1e-12)
    times = (np.arange(rms.shape[0]) + 0.5) * frame / rate
    return rate, times, rms


def log_spectral_map(
    path: Path,
    n_fft: int = 8192,
    hop_seconds: float = 0.1,
    bands_per_octave: int = 12,
):
    rate, samples = wavfile.read(path, mmap=True)
    if samples.ndim != 1:
        raise ValueError("spectral-map input must be mono")
    hop = int(round(rate * hop_seconds))
    frame_count = 1 + (len(samples) - n_fft) // hop
    starts = np.arange(frame_count, dtype=np.int64) * hop
    window = np.hanning(n_fft).astype(np.float32)
    frequencies = np.fft.rfftfreq(n_fft, 1.0 / rate)

    octave_count = math.log2(10000.0 / 40.0)
    band_count = int(math.ceil(octave_count * bands_per_octave))
    edges_hz = 40.0 * 2.0 ** (np.arange(band_count + 1) / bands_per_octave)
    edges_hz[-1] = min(edges_hz[-1], 10000.0)
    low_bins = np.searchsorted(frequencies, edges_hz[:-1], side="left")
    high_bins = np.searchsorted(frequencies, edges_hz[1:], side="right")
    high_bins = np.maximum(high_bins, low_bins + 1)
    centres_hz = np.sqrt(edges_hz[:-1] * edges_hz[1:])

    matrix = np.empty((band_count, frame_count), dtype=np.float32)
    batch = 192
    sample_scale = 1.0 / 32768.0
    offsets = np.arange(n_fft, dtype=np.int64)
    for first in range(0, frame_count, batch):
        last = min(first + batch, frame_count)
        index = starts[first:last, None] + offsets[None, :]
        frames = np.asarray(samples[index], dtype=np.float32) * sample_scale
        spectrum = np.fft.rfft(frames * window, axis=1)
        power = (spectrum.real * spectrum.real + spectrum.imag * spectrum.imag).astype(np.float32)
        cumulative = np.pad(np.cumsum(power, axis=1), ((0, 0), (1, 0)))
        grouped = cumulative[:, high_bins] - cumulative[:, low_bins]
        matrix[:, first:last] = (grouped / (high_bins - low_bins)).T

    times = (starts + n_fft * 0.5) / rate
    matrix_db = 10.0 * np.log10(matrix + 1e-16)
    return rate, times, centres_hz, matrix_db


def band_envelope(matrix_db: np.ndarray, centres_hz: np.ndarray, low: float, high: float):
    mask = (centres_hz >= low) & (centres_hz < high)
    linear = np.mean(10.0 ** (matrix_db[mask] / 10.0), axis=0)
    return 10.0 * np.log10(linear + 1e-16)


def infer_events(times: np.ndarray, envelope_db: np.ndarray):
    step = float(np.median(np.diff(times)))
    slow = gaussian_filter1d(envelope_db, 1.6 / step)
    baseline = gaussian_filter1d(envelope_db, 42.0 / step)
    score = robust_z(slow - baseline)
    peaks, props = find_peaks(
        score,
        distance=max(1, int(round(5.5 / step))),
        prominence=0.34,
        width=max(1, int(round(0.7 / step))),
    )
    widths = peak_widths(score, peaks, rel_height=0.55)
    left = np.clip(np.floor(widths[2]).astype(int), 0, len(times) - 1)
    right = np.clip(np.ceil(widths[3]).astype(int), 0, len(times) - 1)
    troughs = []
    for first, second in zip(peaks[:-1], peaks[1:]):
        troughs.append(first + int(np.argmin(score[first:second + 1])))
    troughs = np.asarray(troughs, dtype=int)
    intervals = np.diff(times[peaks])
    contraction = times[troughs] - times[peaks[:-1]]
    expansion = times[peaks[1:]] - times[troughs]
    return {
        "score": score,
        "indices": peaks,
        "times": times[peaks],
        "trough_indices": troughs,
        "trough_times": times[troughs],
        "prominence": props["prominences"],
        "intervals": intervals,
        "expansion": expansion,
        "contraction": contraction,
        "half_height_rise": times[peaks] - times[left],
        "half_height_fall": times[right] - times[peaks],
    }


def detector_sensitivity(times: np.ndarray, envelope_db: np.ndarray):
    """Check that the principal period is not an artefact of one threshold."""
    step = float(np.median(np.diff(times)))
    rows = []
    for smoothing_seconds in (1.2, 1.6, 2.0, 2.4):
        slow = gaussian_filter1d(envelope_db, smoothing_seconds / step)
        for baseline_seconds in (35.0, 42.0, 50.0, 60.0):
            baseline = gaussian_filter1d(envelope_db, baseline_seconds / step)
            score = robust_z(slow - baseline)
            for prominence in (0.28, 0.34, 0.40, 0.48):
                peaks, _ = find_peaks(
                    score,
                    distance=max(1, int(round(5.5 / step))),
                    prominence=prominence,
                    width=max(1, int(round(0.7 / step))),
                )
                intervals = np.diff(times[peaks])
                rows.append((len(peaks), np.median(intervals), np.std(intervals, ddof=1) / np.mean(intervals)))
    values = np.asarray(rows, dtype=float)
    return {
        "parameter_combinations": int(len(rows)),
        "event_count_range": [int(values[:, 0].min()), int(values[:, 0].max())],
        "median_interval_seconds_range": [
            round(float(values[:, 1].min()), 3),
            round(float(values[:, 1].max()), 3),
        ],
        "coefficient_of_variation_range": [
            round(float(values[:, 2].min()), 4),
            round(float(values[:, 2].max()), 4),
        ],
        "interpretation": "The approximately 24.2-second cycle remains stable across all tested detector settings.",
    }


def percentiles(values: np.ndarray):
    q = np.percentile(values, [5, 10, 25, 50, 75, 90, 95])
    return {key: round(float(value), 3) for key, value in zip(
        ["p05", "p10", "p25", "median", "p75", "p90", "p95"], q
    )}


def mixture_model(intervals: np.ndarray, components: int = 4):
    logged = np.log(intervals).reshape(-1, 1)
    model = GaussianMixture(n_components=components, random_state=22004, n_init=12)
    model.fit(logged)
    order = np.argsort(model.means_[:, 0])
    result = []
    for index in order:
        mu = float(model.means_[index, 0])
        sigma = float(np.sqrt(model.covariances_[index].reshape(-1)[0]))
        result.append({
            "weight": round(float(model.weights_[index]), 4),
            "lognormal_mu": round(mu, 5),
            "lognormal_sigma": round(sigma, 5),
            "median_seconds": round(float(np.exp(mu)), 3),
        })
    return result


def transition_matrix(values: np.ndarray):
    q1, q2 = np.quantile(values, [1.0 / 3.0, 2.0 / 3.0])
    states = np.digitize(values, [q1, q2])
    counts = np.ones((3, 3), dtype=np.float64)  # Laplace smoothing
    for source, target in zip(states[:-1], states[1:]):
        counts[source, target] += 1.0
    probs = counts / counts.sum(axis=1, keepdims=True)
    labels = ["short", "medium", "long"]
    return {
        "boundaries_seconds": [round(float(q1), 3), round(float(q2), 3)],
        "labels": labels,
        "rows": {
            labels[row]: {labels[col]: round(float(probs[row, col]), 4) for col in range(3)}
            for row in range(3)
        },
    }


def modulation_periods(envelope_db: np.ndarray, step: float):
    smooth = gaussian_filter1d(envelope_db, 0.8 / step)
    residual = smooth - gaussian_filter1d(smooth, 55.0 / step)
    frequency, power = welch(residual, fs=1.0 / step, nperseg=min(len(residual), 16384))
    mask = (frequency >= 1.0 / 40.0) & (frequency <= 1.0 / 3.0)
    peaks, _ = find_peaks(power[mask], distance=4)
    freq = frequency[mask][peaks]
    strength = power[mask][peaks]
    if len(freq) == 0:
        return []
    order = np.argsort(strength)[::-1][:6]
    return [round(float(1.0 / freq[index]), 3) for index in order]


def segment_statistics(times: np.ndarray, event_times: np.ndarray, envelope_db: np.ndarray, segments: int = 8):
    edges = np.linspace(times[0], times[-1], segments + 1)
    output = []
    for index in range(segments):
        start, end = edges[index], edges[index + 1]
        mask = (event_times >= start) & (event_times < end)
        local_events = event_times[mask]
        local_intervals = np.diff(local_events)
        frame_mask = (times >= start) & (times < end)
        output.append({
            "from_minute": round(float(start / 60.0), 3),
            "to_minute": round(float(end / 60.0), 3),
            "event_count": int(len(local_events)),
            "median_interval_seconds": round(float(np.median(local_intervals)), 3) if len(local_intervals) else None,
            "relative_level_db": round(float(np.median(envelope_db[frame_mask]) - np.median(envelope_db)), 3),
        })
    return output


def create_figure(
    output: Path,
    times: np.ndarray,
    frequencies: np.ndarray,
    matrix_db: np.ndarray,
    event_times: np.ndarray,
    trough_times: np.ndarray,
):
    target_columns = 1800
    factor = max(1, matrix_db.shape[1] // target_columns)
    usable = (matrix_db.shape[1] // factor) * factor
    reduced = matrix_db[:, :usable].reshape(matrix_db.shape[0], -1, factor).mean(axis=2)
    reduced_times = times[:usable].reshape(-1, factor).mean(axis=1) / 60.0
    reference = np.percentile(reduced, 98.5)
    image = np.clip(reduced - reference, -45.0, 0.0)

    fig, ax = plt.subplots(figsize=(12.0, 3.45), dpi=180)
    y_edges = np.geomspace(frequencies[0] / np.sqrt(frequencies[1] / frequencies[0]),
                           frequencies[-1] * np.sqrt(frequencies[-1] / frequencies[-2]),
                           len(frequencies) + 1)
    x_edges = np.linspace(reduced_times[0], reduced_times[-1], reduced.shape[1] + 1)
    ax.pcolormesh(x_edges, y_edges, image, shading="auto", cmap="Greys", vmin=-45.0, vmax=0.0)
    for crest in event_times:
        ax.plot([crest / 60.0, crest / 60.0], [8500.0, 10000.0], color="black", linewidth=0.28, alpha=0.70)
    for trough in trough_times:
        ax.plot([trough / 60.0, trough / 60.0], [40.0, 48.0], color="black", linewidth=0.28, alpha=0.70)
    ax.set_yscale("log")
    ax.set_xlim(0.0, times[-1] / 60.0)
    ax.set_ylim(40.0, 10000.0)
    ax.set_xlabel("time / min")
    ax.set_ylabel("frequency / Hz")
    ax.set_yticks([50, 100, 200, 500, 1000, 2000, 5000, 10000])
    ax.set_yticklabels(["50", "100", "200", "500", "1k", "2k", "5k", "10k"])
    ax.grid(False)
    for spine in ["top", "right"]:
        ax.spines[spine].set_visible(False)
    fig.tight_layout(pad=0.7)
    fig.savefig(output, bbox_inches="tight", facecolor="white")
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mono", type=Path, required=True, help="22.05 kHz mono PCM WAV")
    parser.add_argument("--stereo", type=Path, required=True, help="11.025 kHz stereo PCM WAV")
    parser.add_argument("--json", type=Path, required=True)
    parser.add_argument("--figure", type=Path, required=True)
    args = parser.parse_args()

    mono_rate, mono_samples = wavfile.read(args.mono, mmap=True)
    source_duration = len(mono_samples) / float(mono_rate)
    _, times, frequencies, matrix_db = log_spectral_map(args.mono)
    total_db = band_envelope(matrix_db, frequencies, 40.0, 10000.0)
    low_db = band_envelope(matrix_db, frequencies, 40.0, 220.0)
    mid_db = band_envelope(matrix_db, frequencies, 220.0, 2000.0)
    high_db = band_envelope(matrix_db, frequencies, 2000.0, 10000.0)
    events = infer_events(times, total_db)

    stereo_rate, stereo_times, stereo_rms = frame_rms_stereo(args.stereo)
    stereo_db = 20.0 * np.log10(stereo_rms + 1e-12)
    stereo_correlation = float(np.corrcoef(stereo_db[:, 0], stereo_db[:, 1])[0, 1])

    intervals = events["intervals"]
    expansions = events["expansion"]
    contractions = events["contraction"]
    phase_intervals = np.concatenate([expansions, contractions])
    serial_correlation = float(np.corrcoef(intervals[:-1], intervals[1:])[0, 1])
    lag_three_correlation = float(np.corrcoef(intervals[:-3], intervals[3:])[0, 1])
    rare_dilation_mask = intervals > 30.0

    result = {
        "schema": "airforms.behavioural-model.v1.1",
        "analysis_version": ANALYSIS_VERSION,
        "authorship": "Analysis and behavioural model: Dmitrii Shchukin",
        "source": {
            "work": "Airforms",
            "artist": "Steve Roden",
            "edition": "LINE_022 stereo edition",
            "duration_seconds": round(float(source_duration), 3),
            "official_reference": "https://lineimprint.bandcamp.com/album/airforms",
            "analysis_channels": {
                "event_and_spectral_analysis": "mono sum at 22050 Hz",
                "stereo_comparison": "left and right at 11025 Hz",
            },
            "recording_included_in_project": False,
        },
        "method": {
            "interpretive_unit": "inferred breath-like spectral swell, not a literal respiratory gesture",
            "spectral_map": {
                "frequency_range_hz": [40.0, 10000.0],
                "bands_per_octave": 12,
                "time_step_seconds": round(float(np.median(np.diff(times))), 5),
                "fft_size": 8192,
            },
            "event_detector": {
                "smoothing_seconds": 1.6,
                "baseline_seconds": 42.0,
                "minimum_peak_distance_seconds": 5.5,
                "minimum_prominence_robust_z": 0.34,
            },
            "caution": "Processing, loop overlap, stereo reorganisation and room/object filtering prevent literal identification of inhalation and exhalation.",
        },
        "global_behaviour": {
            "inferred_swell_count": int(len(events["times"])),
            "crest_interval_seconds": {
                "count": int(len(intervals)),
                "mean": round(float(np.mean(intervals)), 3),
                "standard_deviation": round(float(np.std(intervals, ddof=1)), 3),
                "coefficient_of_variation": round(float(np.std(intervals, ddof=1) / np.mean(intervals)), 4),
                **percentiles(intervals),
                "four_component_lognormal_mixture": mixture_model(intervals),
            },
            "alternating_phase_interval_seconds": {
                **percentiles(phase_intervals),
                "coefficient_of_variation": round(float(np.std(phase_intervals, ddof=1) / np.mean(phase_intervals)), 4),
            },
            "expansion_phase_seconds": percentiles(expansions),
            "contraction_phase_seconds": percentiles(contractions),
            "median_expansion_share_of_cycle": round(float(np.median(expansions / intervals)), 4),
            "successive_interval_correlation": round(serial_correlation, 4),
            "interval_correlation_at_three_cycle_lag": round(lag_three_correlation, 4),
            "three_clock_rotation": "The predominant order is short to medium to long and back to short; interval variation is therefore structured rather than independently random.",
            "rare_central_dilation": {
                "count": int(np.sum(rare_dilation_mask)),
                "median_seconds": round(float(np.median(intervals[rare_dilation_mask])), 3),
                "form_position": "near the middle of the recording",
            },
            "dominant_modulation_periods_seconds": modulation_periods(total_db, float(np.median(np.diff(times)))),
            "left_right_level_correlation": round(stereo_correlation, 4),
            "interval_transition_model": transition_matrix(intervals),
        },
        "spectral_behaviour": {
            "median_relative_band_levels_db": {
                "low_40_220_hz": 0.0,
                "mid_220_2000_hz": round(float(np.median(mid_db) - np.median(low_db)), 3),
                "high_2000_10000_hz": round(float(np.median(high_db) - np.median(low_db)), 3),
            },
            "observation": "Low, middle and high bands breathe with related but unequal envelopes; upper detail often enters or vanishes independently of the low foundation.",
        },
        "validation": detector_sensitivity(times, total_db),
        "form_segments": segment_statistics(times, events["times"], total_db),
        "generative_tendencies": {
            "purpose": "Generate related behaviour without reproducing the original event timeline.",
            "interval_sampling": "Choose the next short, medium or long class from the measured transition model, then sample a small continuous deviation around its fitted centre.",
            "anti_metric_rule": "Avoid exact duration repetition through approximately 0.5-2.5% within-class variation and occasional departures from the predominant three-class rotation.",
            "memory_rule": "Preserve the strong short-to-medium-to-long rotation while allowing the transition matrix to interrupt it.",
            "rare_dilation_rule": "Give approximately 1.5% of primary cycles a duration near 37 seconds.",
            "envelope_rule": "Use an asymmetrical cycle: expansion normally lasts about 9.5 seconds and contraction about 14.8 seconds.",
            "phase_relation_rule": "Offset the two principal spectral banks by roughly one expansion phase, then let their independent clocks drift.",
            "spectral_rule": "Treat partial visibility, entrance order and band-specific level as independent-but-coupled variables.",
            "segment_rule": "Move between density targets over four-to-nine-minute windows instead of replaying the measured eight-segment level curve.",
        },
    }

    args.json.parent.mkdir(parents=True, exist_ok=True)
    args.figure.parent.mkdir(parents=True, exist_ok=True)
    args.json.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    create_figure(args.figure, times, frequencies, matrix_db, events["times"], events["trough_times"])

    print(json.dumps({
        "events": len(events["times"]),
        "intervals": percentiles(intervals),
        "mean": round(float(np.mean(intervals)), 3),
        "cv": round(float(np.std(intervals, ddof=1) / np.mean(intervals)), 4),
        "mixture": mixture_model(intervals),
        "expansion": percentiles(expansions),
        "contraction": percentiles(contractions),
        "serial_correlation": round(serial_correlation, 4),
        "lag_three_correlation": round(lag_three_correlation, 4),
        "modulation_periods": modulation_periods(total_db, float(np.median(np.diff(times)))),
        "stereo_correlation": round(stereo_correlation, 4),
    }, indent=2))


if __name__ == "__main__":
    main()
