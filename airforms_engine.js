/*
    airforms_engine.js — Airforms reconstruction v3

    Copyright © 2026 Dmitrii Shchukin. All rights reserved.

    The JS object never generates audio. It schedules three 24-partial MSP
    banks and four families of noise events. The primary breath scheduler is
    inferred from the complete 56:14 LINE recording: three neighbouring cycle
    classes rotate with rare dilations, while every spectrum crystallises in a
    new internal order.

    outlets 0..2 : setvalue messages for three 24-voice poly~ banks
    outlet 3     : breath / rumble / radio / dust control messages
    outlet 4     : readable state and analysis information
*/

autowatch = 1;
inlets = 1;
outlets = 5;

var PARTIAL_COUNT = 24;
var running = false;
var tempoScale = 1.0;
var densityValue = 0.82;
var initialSeed = 22004;
var rngState = initialSeed | 0;
var spareGaussian = null;

var voiceTasks = [];
var breathTask = null;
var rumbleTask = null;
var radioTask = null;
var dustTask = null;
var eventCount = [0, 0, 0];
var firstEvent = [true, true, true];
var primaryClockState = [0, 1];
var breathClockState = 2;
var formDensityOffset = -0.06;
var formDensityTarget = 0.0;
var formStepsRemaining = 12;

var clockNames = ["short", "medium", "long"];
var clockCentres = [23578.0, 24191.0, 25985.0];
var clockSigmas = [0.018, 0.015, 0.018];
var clockTransitions = [
    [0.0625, 0.8750, 0.0625],
    [0.0213, 0.0638, 0.9149],
    [0.8958, 0.0625, 0.0417]
];
var rareDilationProbability = 0.0148;

// A and B combine persistent tracks from the new SDIF with a few older
// low components and quiet derived sum/double tones. Weights are measured
// amplitude ratios before the perceptual compression applied in runVoice().
var profiles = [
    {
        name: "A",
        frequencies: [
            63.033, 85.185, 94.346, 126.342, 183.496, 241.194,
            296.601, 309.838, 424.690, 480.097, 550.306, 604.573,
            733.802, 846.907, 964.505, 1219.703, 1417.709, 1516.304,
            1660.675, 1770.009, 1856.011, 2439.406, 3422.401, 15723.265
        ],
        weights: [
            0.350, 1.000, 0.300, 0.431, 0.419, 0.100,
            0.727, 0.025, 0.018, 0.015, 0.368, 0.013,
            0.012, 0.010, 0.008, 0.961, 0.007, 0.009,
            0.002, 0.008, 0.002, 0.006, 0.006, 0.004
        ],
        durationMedian: 10800,
        durationSigma: 0.23,
        restMin: 300,
        restMean: 2500,
        amplitudeMin: 0.019,
        amplitudeMax: 0.044,
        centsJitter: 4.0,
        weightExponent: 0.68,
        highLift: 1.45,
        sparseProbability: 0.14,
        mediumProbability: 0.28,
        dropout: 0.025,
        firstOffset: 0
    },
    {
        name: "B",
        frequencies: [
            62.574, 94.336, 126.306, 183.461, 241.125, 296.552,
            309.767, 424.586, 537.677, 550.214, 629.678, 733.675,
            840.503, 1001.296, 1023.019, 1219.705, 1319.571, 1573.233,
            2046.038, 3421.926, 5471.967, 7566.802, 8183.140, 8818.860
        ],
        weights: [
            1.000, 0.474, 0.372, 0.259, 0.088, 0.274,
            0.020, 0.016, 0.014, 0.039, 0.003, 0.012,
            0.001, 0.003, 0.031, 0.015, 0.012, 0.010,
            0.008, 0.001, 0.0014, 0.00045, 0.00039, 0.00041
        ],
        durationMedian: 8800,
        durationSigma: 0.29,
        restMin: 700,
        restMean: 3700,
        amplitudeMin: 0.018,
        amplitudeMax: 0.041,
        centsJitter: 4.8,
        weightExponent: 0.66,
        highLift: 1.50,
        sparseProbability: 0.18,
        mediumProbability: 0.32,
        dropout: 0.035,
        firstOffset: 9500
    },
    {
        name: "C-residue",
        frequencies: [
            40.800, 49.800, 55.180, 62.900, 70.660, 75.370,
            80.080, 84.110, 94.200, 104.970, 135.260, 189.760,
            205.240, 212.640, 228.120, 257.050, 288.680, 311.560,
            349.910, 401.060, 566.590, 789.330, 838.450, 913.140
        ],
        weights: [
            0.450, 0.350, 0.580, 0.250, 0.120, 0.320,
            0.100, 0.200, 0.180, 0.120, 0.080, 0.060,
            0.080, 0.060, 0.050, 0.050, 0.070, 0.060,
            0.040, 0.040, 0.035, 0.030, 0.050, 0.025
        ],
        durationMedian: 5200,
        durationSigma: 0.36,
        restMin: 3600,
        restMean: 6500,
        amplitudeMin: 0.007,
        amplitudeMax: 0.018,
        centsJitter: 9.0,
        weightExponent: 0.78,
        highLift: 1.10,
        sparseProbability: 0.45,
        mediumProbability: 0.35,
        dropout: 0.08,
        firstOffset: 6100
    }
];

function makeTask(callback) {
    return new Task(callback, this);
}

function initialiseTasks() {
    if (voiceTasks.length) {
        return;
    }
    voiceTasks[0] = makeTask(function () { runVoice(0); });
    voiceTasks[1] = makeTask(function () { runVoice(1); });
    voiceTasks[2] = makeTask(function () { runVoice(2); });
    breathTask = makeTask(runBreath);
    rumbleTask = makeTask(runRumble);
    radioTask = makeTask(runRadio);
    dustTask = makeTask(runDust);
}

function randomUnit() {
    var x = rngState | 0;
    x ^= (x << 13);
    x ^= (x >>> 17);
    x ^= (x << 5);
    rngState = x | 0;
    return ((x >>> 0) + 0.5) / 4294967296.0;
}

function randomRange(lo, hi) {
    return lo + (hi - lo) * randomUnit();
}

function randomInt(lo, hiInclusive) {
    return lo + Math.floor(randomUnit() * (hiInclusive - lo + 1));
}

function gaussian() {
    if (spareGaussian !== null) {
        var result = spareGaussian;
        spareGaussian = null;
        return result;
    }
    var u = Math.max(1e-12, randomUnit());
    var v = randomUnit();
    var magnitude = Math.sqrt(-2.0 * Math.log(u));
    spareGaussian = magnitude * Math.sin(2.0 * Math.PI * v);
    return magnitude * Math.cos(2.0 * Math.PI * v);
}

function logNormal(median, sigma) {
    return median * Math.exp(sigma * gaussian());
}

function exponential(mean) {
    return -Math.log(Math.max(1e-12, 1.0 - randomUnit())) * mean;
}

function clamp(value, lo, hi) {
    return Math.max(lo, Math.min(hi, value));
}

function roundTo(value, decimals) {
    var scale = Math.pow(10, decimals);
    return Math.round(value * scale) / scale;
}

function scaledTime(milliseconds) {
    return Math.max(5, milliseconds / tempoScale);
}

function weightedChoice(probabilities) {
    var roll = randomUnit();
    var cumulative = 0.0;
    for (var i = 0; i < probabilities.length; i++) {
        cumulative += probabilities[i];
        if (roll <= cumulative) {
            return i;
        }
    }
    return probabilities.length - 1;
}

function sampleClockCycle(state) {
    var current = clamp(Math.floor(state), 0, clockCentres.length - 1);
    var next = weightedChoice(clockTransitions[current]);
    if (randomUnit() < rareDilationProbability) {
        return {
            name: "dilation",
            interval: clamp(logNormal(37100.0, 0.020), 35000.0, 39500.0),
            nextState: next
        };
    }
    return {
        name: clockNames[current],
        interval: clamp(logNormal(clockCentres[current], clockSigmas[current]), 22000.0, 28500.0),
        nextState: next
    };
}

function sampleExpansion() {
    return clamp(logNormal(9500.0, 0.045), 8400.0, 10500.0);
}

function effectiveDensity() {
    return clamp(densityValue + formDensityOffset, 0.15, 1.0);
}

function chooseFormDensityTarget() {
    var roll = randomUnit();
    if (roll < 0.18) {
        return randomRange(-0.22, -0.14);
    }
    if (roll < 0.43) {
        return randomRange(-0.12, -0.05);
    }
    if (roll < 0.84) {
        return randomRange(-0.025, 0.025);
    }
    return randomRange(0.035, 0.075);
}

function advanceFormDensity() {
    if (formStepsRemaining <= 0) {
        formDensityTarget = chooseFormDensityTarget();
        formStepsRemaining = randomInt(10, 22);
    }
    formDensityOffset += (formDensityTarget - formDensityOffset) * randomRange(0.10, 0.18);
    formDensityOffset += gaussian() * 0.0035;
    formDensityOffset = clamp(formDensityOffset, -0.26, 0.09);
    formStepsRemaining -= 1;
}

function shuffle(values) {
    var result = values.slice();
    for (var i = result.length - 1; i > 0; i--) {
        var j = Math.floor(randomUnit() * (i + 1));
        var tmp = result[i];
        result[i] = result[j];
        result[j] = tmp;
    }
    return result;
}

function allIndices(count) {
    var result = [];
    for (var i = 0; i < count; i++) {
        result.push(i);
    }
    return result;
}

function crystallisationPattern(count) {
    var roll = randomUnit();
    var order = [];
    var i;

    if (roll < 0.15) {
        return {name: "low-to-high", order: allIndices(count), seedCount: 1};
    }
    if (roll < 0.33) {
        order = allIndices(count).reverse();
        return {name: "high-to-low", order: order, seedCount: 1};
    }
    if (roll < 0.49) {
        var centre = (count - 1) / 2.0;
        var scored = [];
        for (i = 0; i < count; i++) {
            scored.push({index: i, score: Math.abs(i - centre) + randomUnit() * 0.05});
        }
        scored.sort(function (a, b) { return a.score - b.score; });
        for (i = 0; i < scored.length; i++) {
            order.push(scored[i].index);
        }
        return {name: "centre-out", order: order, seedCount: 2};
    }
    if (roll < 0.61) {
        var left = 0;
        var right = count - 1;
        while (left <= right) {
            order.push(left);
            if (right !== left) {
                order.push(right);
            }
            left += 1;
            right -= 1;
        }
        return {name: "edges-in", order: order, seedCount: 2};
    }
    if (roll < 0.88) {
        var seedCount = randomInt(2, 4);
        var seeds = shuffle(allIndices(count)).slice(0, seedCount);
        var seedMap = {};
        for (i = 0; i < seeds.length; i++) {
            seedMap[seeds[i]] = true;
        }
        var remainder = [];
        for (i = 0; i < count; i++) {
            if (!seedMap[i]) {
                var distance = count;
                for (var s = 0; s < seeds.length; s++) {
                    distance = Math.min(distance, Math.abs(i - seeds[s]));
                }
                remainder.push({index: i, score: distance + randomUnit() * 1.5});
            }
        }
        remainder.sort(function (a, b) { return a.score - b.score; });
        order = seeds.slice();
        for (i = 0; i < remainder.length; i++) {
            order.push(remainder[i].index);
        }
        return {name: "constellation", order: order, seedCount: seedCount};
    }
    return {name: "scatter", order: shuffle(allIndices(count)), seedCount: 1};
}

function chooseActiveCount(profile) {
    var roll = randomUnit();
    if (roll < profile.sparseProbability) {
        return randomInt(2, 6);
    }
    if (roll < profile.sparseProbability + profile.mediumProbability) {
        return randomInt(9, 18);
    }
    return PARTIAL_COUNT;
}

function start() {
    initialiseTasks();
    if (running) {
        return;
    }
    running = true;
    for (var i = 0; i < profiles.length; i++) {
        voiceTasks[i].schedule(scaledTime(profiles[i].firstOffset));
    }
    breathTask.schedule(scaledTime(700));
    rumbleTask.schedule(scaledTime(3600));
    radioTask.schedule(scaledTime(6800));
    dustTask.schedule(scaledTime(1400));
    outlet(4, ["running", 1, "partials", PARTIAL_COUNT, "seed", initialSeed, "density", roundTo(densityValue, 2)]);
}

function stop() {
    initialiseTasks();
    running = false;
    for (var i = 0; i < voiceTasks.length; i++) {
        voiceTasks[i].cancel();
        outlet(i, ["setvalue", 0, "stop"]);
    }
    breathTask.cancel();
    rumbleTask.cancel();
    radioTask.cancel();
    dustTask.cancel();
    outlet(3, ["breath", 0.0, 10.0, 10.0, 250.0]);
    outlet(3, ["rumble", 0.0, 10.0, 10.0, 250.0, 8.0, 12.2, 140.0]);
    outlet(3, ["radio", 800.0, 800.0, 50.0, 8.0, 2.0, 0.0, 10.0, 10.0, 250.0]);
    outlet(4, ["running", 0]);
}

function reset() {
    var wasRunning = running;
    stop();
    rngState = initialSeed | 0;
    spareGaussian = null;
    eventCount = [0, 0, 0];
    firstEvent = [true, true, true];
    primaryClockState = [0, 1];
    breathClockState = 2;
    formDensityOffset = -0.06;
    formDensityTarget = 0.0;
    formStepsRemaining = 12;
    if (wasRunning) {
        start();
    } else {
        outlet(4, ["ready", "partials", PARTIAL_COUNT, "seed", initialSeed]);
    }
}

function seed(value) {
    var parsed = Math.floor(Number(value));
    if (!isFinite(parsed)) {
        return;
    }
    initialSeed = parsed || 1;
    rngState = initialSeed | 0;
    spareGaussian = null;
    outlet(4, ["seed", initialSeed]);
}

function tempo(value) {
    tempoScale = clamp(Number(value) || 1.0, 0.20, 4.0);
    outlet(4, ["tempo", roundTo(tempoScale, 2)]);
}

function density(value) {
    densityValue = clamp(Number(value) || 0.0, 0.0, 1.0);
    outlet(4, ["density", roundTo(densityValue, 2)]);
}

function runVoice(index) {
    if (!running) {
        return;
    }

    var profile = profiles[index];
    var primary = index < 2;
    if (index === 0) {
        advanceFormDensity();
    }
    var localDensity = effectiveDensity();
    var duration;
    var rest;
    var commonPeakTime;
    var clockCycle = null;

    if (primary) {
        clockCycle = sampleClockCycle(primaryClockState[index]);
        primaryClockState[index] = clockCycle.nextState;
        duration = clockCycle.interval;
        rest = 0.0;
        commonPeakTime = sampleExpansion();
    } else {
        duration = clamp(logNormal(profile.durationMedian, profile.durationSigma), 2600, 20500);
        var restMultiplier = 1.35 - 0.70 * localDensity;
        rest = profile.restMin + exponential(profile.restMean * restMultiplier);
        rest = clamp(rest, profile.restMin, profile.restMin + profile.restMean * 3.2);
        commonPeakTime = duration * randomRange(0.66, 0.82);
    }

    var skipChance = primary ? (1.0 - localDensity) * 0.18 : (1.0 - localDensity) * 0.48;
    var skipped = randomUnit() < skipChance;

    if (!skipped) {
        var pattern = crystallisationPattern(PARTIAL_COUNT);
        var activeCount = chooseActiveCount(profile);
        if (primary && localDensity < 0.42 && activeCount === PARTIAL_COUNT && randomUnit() < 0.55) {
            activeCount = randomInt(9, 18);
        }
        var activeOrder = pattern.order.slice(0, activeCount);
        var activeMap = {};
        var rankMap = {};
        var p;
        for (p = 0; p < activeOrder.length; p++) {
            activeMap[activeOrder[p]] = true;
            rankMap[activeOrder[p]] = p;
        }

        var peak = randomRange(profile.amplitudeMin, profile.amplitudeMax);
        peak *= 0.62 + 0.52 * localDensity;
        var commonCents = gaussian() * profile.centsJitter * 0.40;
        var spanFraction = pattern.name === "constellation" ? randomRange(0.38, 0.64) : randomRange(0.22, 0.57);
        var crystallisationSpan = commonPeakTime * (primary ? randomRange(0.68, 0.96) : spanFraction);
        if (!primary) {
            crystallisationSpan = duration * spanFraction;
        }
        var commonHold = primary ? randomRange(120.0, 520.0) : duration * randomRange(0.025, 0.095);

        for (p = 0; p < PARTIAL_COUNT; p++) {
            if (!activeMap[p]) {
                outlet(index, ["setvalue", p + 1, "stop"]);
                continue;
            }

            var rank = rankMap[p];
            var delay;
            if (pattern.name === "constellation" && rank < pattern.seedCount) {
                delay = randomRange(0, commonPeakTime * 0.045);
            } else {
                var adjustedRank = rank;
                var adjustedCount = activeCount;
                if (pattern.name === "constellation") {
                    adjustedRank = rank - pattern.seedCount + 1;
                    adjustedCount = Math.max(2, activeCount - pattern.seedCount + 1);
                }
                delay = crystallisationSpan * adjustedRank / Math.max(1, adjustedCount - 1);
                delay += gaussian() * commonPeakTime * 0.018;
            }
            delay = clamp(delay, 0, commonPeakTime - 280);

            var localCents = commonCents + gaussian() * profile.centsJitter * 0.60;
            var frequency = profile.frequencies[p] * Math.pow(2.0, localCents / 1200.0);
            var weight = Math.pow(Math.max(0.0002, profile.weights[p]), profile.weightExponent);
            var highPosition = clamp(Math.log(Math.max(1.0, frequency / 500.0)) / Math.log(32.0), 0, 1);
            weight *= 1.0 + (profile.highLift - 1.0) * highPosition;
            if (frequency > 10000) {
                weight *= 0.35;
            }
            var amplitude = peak * weight * Math.pow(10.0, gaussian() * 1.8 / 20.0);
            if (p > 1 && randomUnit() < profile.dropout) {
                amplitude *= randomRange(0.05, 0.25);
            }

            var localHold = commonHold * randomRange(0.75, 1.25);
            var desiredAttack = (commonPeakTime - delay) * randomRange(0.92, 1.06);
            var maximumAttack = Math.max(180, duration - delay - localHold - 420);
            var localAttack = clamp(desiredAttack, 180, maximumAttack);
            var localRelease = Math.max(380, duration - delay - localAttack - localHold);
            var glide = firstEvent[index] ? 8.0 : scaledTime(randomRange(320, 2400));

            outlet(index, [
                "setvalue", p + 1, "event",
                roundTo(frequency, 4),
                roundTo(amplitude, 6),
                roundTo(scaledTime(delay), 1),
                roundTo(scaledTime(localAttack), 1),
                roundTo(scaledTime(localHold), 1),
                roundTo(scaledTime(localRelease), 1),
                roundTo(glide, 1)
            ]);
        }

        firstEvent[index] = false;
        eventCount[index] += 1;
        var stateMessage = [
            profile.name,
            "event", eventCount[index],
            "pattern", pattern.name,
            "partials", activeCount,
            "duration_s", roundTo(duration / 1000.0, 2)
        ];
        if (primary) {
            stateMessage = stateMessage.concat([
                "clock", clockCycle.name,
                "expansion_s", roundTo(commonPeakTime / 1000.0, 2),
                "contraction_s", roundTo((duration - commonPeakTime) / 1000.0, 2),
                "form_density", roundTo(localDensity, 3)
            ]);
        } else {
            stateMessage = stateMessage.concat(["rest_s", roundTo(rest / 1000.0, 2)]);
        }
        outlet(4, stateMessage);
    } else {
        outlet(4, [
            profile.name,
            "skip",
            "clock", primary ? clockCycle.name : "residue",
            "duration_s", roundTo(duration / 1000.0, 2),
            "rest_s", roundTo(rest / 1000.0, 2)
        ]);
    }

    voiceTasks[index].schedule(scaledTime(duration + rest));
}

function runBreath() {
    if (!running) {
        return;
    }
    var cycle = sampleClockCycle(breathClockState);
    breathClockState = cycle.nextState;
    var duration = cycle.interval;
    var attack = sampleExpansion();
    var hold = randomRange(120.0, 520.0);
    var release = Math.max(450, duration - attack - hold);
    var localDensity = effectiveDensity();
    var amplitude = randomRange(0.025, 0.075) * (0.55 + 0.55 * localDensity);
    outlet(3, [
        "breath", roundTo(amplitude, 6),
        roundTo(scaledTime(attack), 1),
        roundTo(scaledTime(hold), 1),
        roundTo(scaledTime(release), 1)
    ]);
    breathTask.schedule(scaledTime(duration));
    outlet(4, [
        "noise-breath",
        "clock", cycle.name,
        "expansion_s", roundTo(attack / 1000.0, 2),
        "contraction_s", roundTo((duration - attack) / 1000.0, 2)
    ]);
}

function runRumble() {
    if (!running) {
        return;
    }
    var duration = clamp(logNormal(6900, 0.36), 2800, 14500);
    var attack = duration * randomRange(0.20, 0.45);
    var hold = duration * randomRange(0.04, 0.15);
    var release = Math.max(500, duration - attack - hold);
    var localDensity = effectiveDensity();
    var amplitude = randomRange(0.060, 0.200) * (0.50 + 0.65 * localDensity);
    var rate1 = randomUnit() < 0.35 ? randomRange(5.2, 6.0) : randomRange(7.6, 8.4);
    var rate2 = randomUnit() < 0.22 ? randomRange(18.3, 19.7) : randomRange(11.7, 12.8);
    var cutoff = randomRange(105, 245);
    outlet(3, [
        "rumble", roundTo(amplitude, 6),
        roundTo(scaledTime(attack), 1),
        roundTo(scaledTime(hold), 1),
        roundTo(scaledTime(release), 1),
        roundTo(rate1 * tempoScale, 3),
        roundTo(rate2 * tempoScale, 3),
        roundTo(cutoff, 1)
    ]);
    var rest = clamp(1200 + exponential(3600 * (1.20 - 0.45 * localDensity)), 1200, 10500);
    rumbleTask.schedule(scaledTime(duration + rest));
}

function runRadio() {
    if (!running) {
        return;
    }
    var centres = [320.0, 480.0, 630.0, 838.0, 1001.0, 1023.0, 1220.0, 1661.0, 2410.0, 3422.0];
    var startCentre = centres[randomInt(0, centres.length - 1)];
    var endCentre = centres[randomInt(0, centres.length - 1)];
    if (Math.abs(endCentre - startCentre) < 80) {
        endCentre *= randomRange(0.72, 1.38);
    }
    var duration = clamp(logNormal(5200, 0.42), 1800, 11000);
    var attack = duration * randomRange(0.16, 0.43);
    var hold = duration * randomRange(0.02, 0.12);
    var release = Math.max(300, duration - attack - hold);
    var q = randomRange(5.0, 28.0);
    var modulationRate = randomUnit() < 0.18 ? randomRange(7.5, 12.5) : randomRange(0.55, 5.8);
    var localDensity = effectiveDensity();
    var amplitude = randomRange(0.070, 0.300) * (0.45 + 0.70 * localDensity);
    outlet(3, [
        "radio",
        roundTo(startCentre, 2),
        roundTo(endCentre, 2),
        roundTo(scaledTime(duration * randomRange(0.65, 1.0)), 1),
        roundTo(q, 2),
        roundTo(modulationRate * tempoScale, 3),
        roundTo(amplitude, 6),
        roundTo(scaledTime(attack), 1),
        roundTo(scaledTime(hold), 1),
        roundTo(scaledTime(release), 1)
    ]);
    var rest = clamp(1800 + exponential(5200 * (1.25 - 0.55 * localDensity)), 1800, 15000);
    radioTask.schedule(scaledTime(duration + rest));
}

function runDust() {
    if (!running) {
        return;
    }
    var localDensity = effectiveDensity();
    if (randomUnit() < 0.28 + 0.70 * localDensity) {
        var centres = [390.0, 560.0, 838.0, 1023.0, 1220.0, 1680.0, 2410.0, 3422.0, 5472.0];
        var centre = centres[randomInt(0, centres.length - 1)];
        centre *= Math.pow(2.0, gaussian() * 12.0 / 1200.0);
        var amplitude = randomRange(0.150, 0.650) * (0.40 + 0.75 * localDensity);
        var decay = randomRange(45, 720);
        var q = randomRange(4.0, 32.0);
        // Ordering is chosen so unpack emits centre and Q before amplitude.
        outlet(3, [
            "dust",
            roundTo(amplitude, 5),
            roundTo(scaledTime(decay), 1),
            roundTo(q, 2),
            roundTo(centre, 2)
        ]);
    }
    var meanInterval = 2800 / Math.max(0.25, 0.42 + localDensity);
    var next = clamp(exponential(meanInterval), 260, 10500);
    dustTask.schedule(scaledTime(next));
}

function dump() {
    for (var i = 0; i < profiles.length; i++) {
        outlet(4, [profiles[i].name, "frequencies"].concat(profiles[i].frequencies));
    }
}

initialiseTasks();
outlet(4, ["ready", "partials", PARTIAL_COUNT, "seed", initialSeed]);
