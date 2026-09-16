.pragma library

function bytes(b) {
    b = b || 0
    if (b >= 1099511627776) return (b / 1099511627776).toFixed(1) + " TB"
    if (b >= 1073741824) return (b / 1073741824).toFixed(1) + " GB"
    if (b >= 1048576) return Math.round(b / 1048576) + " MB"
    if (b >= 1024) return Math.round(b / 1024) + " KB"
    return Math.round(b) + " B"
}

function isDark(theme) {
    return theme.backgroundColor.hslLightness < 0.5
}

function hue(name, theme) {
    var dark = isDark(theme)
    var l = dark ? 0.62 : 0.42
    switch (name) {
    case "temp": return Qt.hsla(0.03, 0.78, l, 1)
    case "memory": return Qt.hsla(0.76, 0.6, l + 0.04, 1)
    case "down": return Qt.hsla(0.52, 0.75, l, 1)
    case "up": return Qt.hsla(0.10, 0.9, l, 1)
    case "power": return Qt.hsla(0.13, 0.85, l, 1)
    case "fan": return Qt.hsla(0.45, 0.55, l, 1)
    default: return theme.highlightColor
    }
}

function heat(v, warn, crit, theme) {
    if (v >= crit) return theme.negativeTextColor
    if (v >= warn) return theme.neutralTextColor
    return theme.textColor
}

function heatStrong(v, warn, crit, theme) {
    if (v >= crit) return theme.negativeTextColor
    if (v >= warn) return theme.neutralTextColor
    return theme.positiveTextColor
}
