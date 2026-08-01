#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const path = require("path");
const vm = require("vm");

function MockTask(callback, scope) {
    this.callback = callback.bind(scope);
    this.scheduled = [];
    this.cancelled = false;
}

MockTask.prototype.schedule = function (milliseconds) {
    this.scheduled.push(milliseconds);
};

MockTask.prototype.cancel = function () {
    this.cancelled = true;
};

const messages = [[], [], [], [], []];
const context = {
    Task: MockTask,
    outlet: function (index, message) {
        messages[index].push(message);
    },
    post: function () {},
    console: console,
    Math: Math,
    Date: Date,
    isFinite: isFinite
};

const enginePath = path.join(__dirname, "..", "airforms_engine.js");
vm.runInNewContext(fs.readFileSync(enginePath, "utf8"), context, {filename: enginePath});

assert.strictEqual(context.PARTIAL_COUNT, 24);
assert.deepStrictEqual(Array.from(context.clockNames), ["short", "medium", "long"]);

context.start();
assert.strictEqual(context.voiceTasks[0].scheduled[0], 5);
assert.strictEqual(context.voiceTasks[1].scheduled[0], 9500);
assert.strictEqual(context.voiceTasks[2].scheduled[0], 6100);

messages.forEach(function (outletMessages) {
    outletMessages.length = 0;
});
context.runVoice(0);

const partialEvents = messages[0].filter(function (message) {
    return message[0] === "setvalue" && message[2] === "event";
});
assert(partialEvents.length >= 2 && partialEvents.length <= 24);

const scheduledCycle = context.voiceTasks[0].scheduled[context.voiceTasks[0].scheduled.length - 1];
assert(scheduledCycle >= 22000 && scheduledCycle <= 39500);
partialEvents.forEach(function (message) {
    const envelopeDuration = message[5] + message[6] + message[7] + message[8];
    assert(Math.abs(envelopeDuration - scheduledCycle) < 3.0);
});

const stateMessage = messages[4].filter(function (message) {
    return message[0] === "A" && message[1] === "event";
}).pop();
assert(stateMessage.includes("clock"));
assert(stateMessage.includes("expansion_s"));
assert(stateMessage.includes("contraction_s"));

context.rngState = 22004;
context.spareGaussian = null;
let state = 0;
let dilationCount = 0;
let rotatingTransitions = 0;
const intervals = [];
for (let i = 0; i < 12000; i += 1) {
    const previousState = state;
    const cycle = context.sampleClockCycle(state);
    state = cycle.nextState;
    intervals.push(cycle.interval);
    if (cycle.name === "dilation") {
        dilationCount += 1;
    }
    if ((previousState === 0 && state === 1) ||
        (previousState === 1 && state === 2) ||
        (previousState === 2 && state === 0)) {
        rotatingTransitions += 1;
    }
}

intervals.sort(function (a, b) { return a - b; });
const medianInterval = intervals[Math.floor(intervals.length / 2)];
const dilationRate = dilationCount / intervals.length;
const rotationRate = rotatingTransitions / intervals.length;
assert(medianInterval > 23800 && medianInterval < 25500);
assert(dilationRate > 0.008 && dilationRate < 0.024);
assert(rotationRate > 0.84);

const expansions = [];
for (let i = 0; i < 4000; i += 1) {
    expansions.push(context.sampleExpansion());
}
expansions.sort(function (a, b) { return a - b; });
const medianExpansion = expansions[Math.floor(expansions.length / 2)];
assert(medianExpansion > 9200 && medianExpansion < 9800);

console.log(JSON.stringify({
    partial_events: partialEvents.length,
    scheduled_cycle_seconds: Number((scheduledCycle / 1000).toFixed(3)),
    simulated_median_cycle_seconds: Number((medianInterval / 1000).toFixed(3)),
    simulated_median_expansion_seconds: Number((medianExpansion / 1000).toFixed(3)),
    simulated_rotation_rate: Number(rotationRate.toFixed(4)),
    simulated_dilation_rate: Number(dilationRate.toFixed(4))
}, null, 2));
