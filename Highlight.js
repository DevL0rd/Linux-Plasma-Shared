.pragma library

function escape(text) {
    return String(text === undefined || text === null ? "" : text)
        .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
}

function matches(text, query) {
    if (!query) return true
    return String(text || "").toLowerCase().indexOf(String(query).toLowerCase()) >= 0
}

function matchesAny(texts, query) {
    if (!query) return true
    for (var i = 0; i < texts.length; i++)
        if (matches(texts[i], query)) return true
    return false
}

function mark(text, query, color) {
    var source = String(text === undefined || text === null ? "" : text)
    if (!query) return escape(source)
    var at = source.toLowerCase().indexOf(String(query).toLowerCase())
    if (at < 0) return escape(source)
    var end = at + String(query).length
    return escape(source.substring(0, at)) + "<b><font color=\"" + color + "\">"
        + escape(source.substring(at, end)) + "</font></b>" + escape(source.substring(end))
}
