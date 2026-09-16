.pragma library
.import "Ring.js" as Ring

function make(len) {
    return { len: len, rings: {} }
}

function push(history, key, value) {
    var ring = history.rings[key]
    if (!ring) {
        ring = Ring.make(history.len)
        history.rings[key] = ring
    }
    Ring.push(ring, value)
}

function values(history, key) {
    var ring = history.rings[key]
    return ring ? Ring.values(ring) : []
}

function resized(history, len) {
    var next = make(len)
    for (var key in history.rings) {
        var old = Ring.values(history.rings[key])
        for (var i = Math.max(0, old.length - len); i < old.length; i++)
            push(next, key, old[i])
    }
    return next
}

function stats(vals) {
    var n = vals ? vals.length : 0
    if (n === 0)
        return { now: 0, peak: 0, avg: 0, count: 0 }
    var peak = vals[0], sum = 0
    for (var i = 0; i < n; i++) {
        if (vals[i] > peak) peak = vals[i]
        sum += vals[i]
    }
    return { now: vals[n - 1], peak: peak, avg: sum / n, count: n }
}
