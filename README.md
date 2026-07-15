# Airforms — Compact Max/MSP Reconstruction

A compact behavioural reconstruction of Steve Roden's *Airforms*. The aim of this project is to study the temporal and spectral behaviour of breath-derived sound through a model informed by Roden's work. The reconstruction concentrates on overlapping spectral states, slow irregular breathing, drifting partial tones, and a quieter field of incidental noise.

The scope is deliberately limited to the organisation of the stereo sound material. The five plaster forms, the original multichannel spatial design, and the acoustic response of the installation space are treated as historical and material conditions rather than simulated components.

## Running the Project

1. Open `main.maxpat` in Max 8.6 or later. Keep all project files in their existing relative locations.
2. Lower the system playback level before starting. The patch is designed for quiet listening.
3. Enable the `START / DSP` toggle.
4. Begin with the default values: `master = -3 dB`, `tempo = 1.0`, `density = 0.82`, and `seed = 22004`.

`tempo` scales event durations between 0.2 and 4.0. `density` changes the probability of omissions, the length of rests, and the activity of the noise layer. Reusing the same `seed` reproduces the same probabilistic sequence after `reset`.

## Architecture

- `airforms_engine.js` contains the spectral data and event scheduler. It does not generate audio.
- Three `poly~ airforms_partial 24` objects form independent banks of 24 sinusoidal voices.
- Banks A and B combine tracks extracted from the newer SDIF analysis, retained low components from the first analysis, and a small number of quiet sum or doubled tones.
- Every breath selects a crystallisation order: low-to-high, high-to-low, centre-out, edges-in, constellation, or scatter. Some events retain only 2–6 or 9–18 of the 24 available components.
- C-residue uses stable sidebands measured in the WAV. It is a quiet field of spectral residue, not a proposed third chord in Roden's work.
- `airforms_noise.maxpat` produces four related families: filtered breath, amplitude-modulated rumble, scanning radio-like interference, and short resonant fragments.
- A weak A × B path introduces sum-and-difference intermodulation only while the two principal fields overlap.
- Independent durations and rests gradually displace the layers in phase. This long-term divergence is more important to the model than a fixed chord sequence.

## Source Measurements

Detailed observations are documented in `ANALYSIS.md`; machine-readable values are stored in `analysis/measurements.json`.

The supplied mono WAV lasts 77.062 seconds. Its principal breath peaks occur near 2.9, 15.3, 29.4, 45.5, 58.5, and 70.1 seconds. Intervals between 11.6 and 16.1 seconds are quasi-periodic but not metric. The newer SDIF contains up to 13 tracked components in field A and 17 in field B, including faint upper bands extending to approximately 15.7 kHz. The low noise layer contains stable amplitude-modulation regions near 5.5, 8, 12.2, and 19 Hz; the mid-frequency radio-like material is modulated primarily between 0.6 and 5.8 Hz.

## Scope and Limitations

The extended sinusoidal banks and the complex noise engine do not reproduce the acoustic filtering of the plaster shells, loudspeaker nonlinearities, or the response of the original room. The patch should therefore be understood as a behavioural and analytical model of recurrence, spectral disclosure, and unequal breathing cycles. Future versions could incorporate organ-pipe samples, measured impulse responses, or a five-channel spatial configuration.

## Project Essay

The concept, analysis, frequency inventories, and Max/MSP implementation are documented in English, German, and Russian in `output/pdf/Airforms_Reconstruction_Description_EN-DE-RU.pdf`.

## Authorship

Concept, analysis, design, and implementation: Dmitrii Shchukin.

Copyright © 2026 Dmitrii Shchukin. All rights reserved.
