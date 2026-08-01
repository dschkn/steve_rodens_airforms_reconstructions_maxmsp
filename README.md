# Airforms — Compact Max/MSP Reconstruction

A compact behavioural reconstruction of Steve Roden's *Airforms*. The aim of this project is to study the temporal and spectral behaviour of breath-derived sound through a model informed by Roden's work. The reconstruction concentrates on overlapping spectral states, slow irregular breathing, drifting partial tones, and a quieter field of incidental noise.

The scope is deliberately limited to the organisation of the stereo sound material. The five plaster forms, the original multichannel spatial design, and the acoustic response of the installation space are treated as historical and material conditions rather than simulated components.

## Running the Project

1. Open `main.maxpat` in Max 8.6 or later. Keep all project files in their existing relative locations.
2. Lower the system playback level before starting. The patch is designed for quiet listening.
3. Enable the `START / DSP` toggle.
4. Begin with the default values: `master = -3 dB`, `tempo = 1.0`, `density = 0.82`, and `seed = 22004`.

`tempo` scales event durations between 0.2 and 4.0. `density` sets the centre of the activity range; the engine then moves slowly between denser and thinner targets over several minutes. Reusing the same `seed` reproduces the same probabilistic sequence after `reset`.

## Architecture

- `airforms_engine.js` contains the spectral data and event scheduler. It does not generate audio.
- Three `poly~ airforms_partial 24` objects form independent banks of 24 sinusoidal voices.
- Banks A and B combine tracks extracted from the newer SDIF analysis, retained low components from the first analysis, and a small number of quiet sum or doubled tones.
- Their principal cycles rotate through measured short, medium, and long classes centred near 23.58, 24.19, and 25.99 seconds. The transition model preserves the predominant three-clock order but can interrupt it.
- Spectral expansion normally lasts about 9.5 seconds and contraction about 14.8 seconds. Bank B begins approximately one expansion phase after A; the two clocks then drift independently.
- Every breath selects a crystallisation order: low-to-high, high-to-low, centre-out, edges-in, constellation, or scatter. Some events retain only 2–6 or 9–18 of the 24 available components.
- C-residue uses stable sidebands measured in the WAV. It is a quiet field of spectral residue, not a proposed third chord in Roden's work.
- `airforms_noise.maxpat` produces four related families: filtered breath, amplitude-modulated rumble, scanning radio-like interference, and short resonant fragments. The broad breath follows the measured asymmetric cycle; the other noise families retain shorter independent clocks.
- A weak A × B path introduces sum-and-difference intermodulation only while the two principal fields overlap.
- Slow density targets last roughly 10–22 primary cycles, producing multi-minute accumulation and thinning without replaying the original recording's timeline.

## Source Measurements

Detailed observations are documented in `ANALYSIS.md`. Earlier excerpt and SDIF measurements remain in `analysis/measurements.json`; full-recording tendencies are stored in `analysis/airforms_full_recording_behaviour.json`. The source recording itself is not included.

The official LINE_022 stereo edition lasts 56:14.29. Analysis identifies 136 major spectral swell crests. Their complete cycles have a median of 24.2 seconds and rotate through three narrow duration classes; two rare dilations reach roughly 37 seconds. Across 64 detector configurations, the event count remains 136–137 and the median cycle 24.1–24.4 seconds. The time-frequency map in `analysis/airforms_full_recording_spectral_map.png` places time horizontally and logarithmic frequency vertically.

The earlier supplied mono excerpt lasts 77.062 seconds and captures the alternating phase scale: its principal events are separated by 11.6–16.1 seconds. The newer SDIF contains up to 13 tracked components in field A and 17 in field B, including faint upper bands extending to approximately 15.7 kHz. The low noise layer contains stable amplitude-modulation regions near 5.5, 8, 12.2, and 19 Hz; the mid-frequency radio-like material is modulated primarily between 0.6 and 5.8 Hz.

## Scope and Limitations

The extended sinusoidal banks and the complex noise engine do not reproduce the acoustic filtering of the plaster shells, loudspeaker nonlinearities, or the response of the original room. The analysis treats a "breath" as an inferred spectral swell rather than a literal physiological inhalation or exhalation. The patch is therefore a behavioural model of recurrence, spectral disclosure, and unequal cycles, not an event-by-event transcription. Future versions could incorporate organ-pipe samples, measured impulse responses, or a five-channel spatial configuration.

## Project Essay

The concept, analysis, frequency inventories, and Max/MSP implementation are documented in English, German, and Russian in `output/pdf/Airforms_Reconstruction_Description_EN-DE-RU.pdf`.

## Authorship

Concept, analysis, design, and implementation: Dmitrii Shchukin.

Copyright © 2026 Dmitrii Shchukin. All rights reserved.
