.pragma library

var ORDER = ["tiny", "small", "medium", "full"]
var TINY = 0
var SMALL = 1
var MEDIUM = 2
var FULL = 3

function index(stageName) {
    var found = ORDER.indexOf(stageName)
    if (found < 0) {
        console.warn("PopStage: unknown stage name", stageName)
        return FULL
    }
    return found
}

function name(stageIndex) {
    if (stageIndex < 0 || stageIndex >= ORDER.length) {
        console.warn("PopStage: stage index out of range", stageIndex)
        return ORDER[FULL]
    }
    return ORDER[stageIndex]
}

function span(items, spacing, key) {
    var sum = 0
    var count = 0
    for (var i = 0; i < items.length; ++i) {
        if (items[i].max <= 0)
            continue
        sum += items[i][key]
        count++
    }
    return sum + Math.max(0, count - 1) * spacing
}

function share(total, items, spacing) {
    var picks = []
    var used = 0
    var count = 0
    var i
    for (i = 0; i < items.length; ++i) {
        if (items[i].max <= 0) {
            picks.push(-1)
            continue
        }
        picks.push(items[i].low)
        used += items[i].sizes[items[i].low]
        count++
    }
    var left = total - used - Math.max(0, count - 1) * spacing
    for (var round = 0; round < ORDER.length; ++round) {
        for (i = 0; i < items.length; ++i) {
            if (picks[i] < 0 || picks[i] >= items[i].high)
                continue
            var cost = items[i].sizes[picks[i] + 1] - items[i].sizes[picks[i]]
            if (cost > left)
                break
            left -= cost
            picks[i]++
        }
    }
    var out = []
    for (i = 0; i < items.length; ++i)
        out.push(picks[i] < 0 ? 0 : items[i].sizes[picks[i]])
    for (i = 0; i < items.length && left > 0; ++i) {
        if (!items[i].flex)
            continue
        var extra = Math.min(left, items[i].max - out[i])
        out[i] += extra
        left -= extra
    }
    return out
}
