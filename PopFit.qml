import QtQuick
import org.kde.kirigami as Kirigami
import "PopStage.js" as Stage

QtObject {
    id: fit

    property bool vertical: false
    property real thickness: 0
    property real span: 0
    property real spacing: Kirigami.Units.largeSpacing
    property real fixed: 0
    property var items: []
    property bool shrink: true
    property bool flushEnds: false

    readonly property real inset: Math.max(2, Math.round(thickness * 0.08))
    readonly property real endInset: flushEnds && !vertical ? 0 : inset
    readonly property real innerThickness: Math.max(10, thickness - inset * 2)
    readonly property real tightPadding: Kirigami.Units.smallSpacing
    readonly property real sidePadding: flushEnds && !vertical ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing * 1.25
    readonly property real loosePadding: sidePadding * 2
    readonly property real chipsFull: Stage.span(items, spacing, "max")
    readonly property real chipsLean: Stage.span(items, spacing, "min")
    readonly property real lead: fixed > 0 && chipsFull > 0 ? fixed + spacing : fixed

    readonly property real fullContent: lead + chipsFull
    readonly property real leanContent: lead + chipsLean
    readonly property real preferredSpan: Math.ceil(Math.max(thickness, fullContent + sidePadding * 2 + endInset * 2))
    readonly property real minimumSpan: Math.ceil(Math.max(thickness, leanContent + tightPadding * 2 + endInset * 2))

    readonly property real room: shrink ? span - endInset * 2 - tightPadding * 2 - lead + 1 : 1e6
    readonly property var share: Stage.share(room, items, spacing)
    readonly property real content: {
        let sum = 0
        let count = 0
        for (const size of share) {
            if (size <= 0)
                continue
            sum += size
            count++
        }
        return lead + sum + Math.max(0, count - 1) * spacing
    }
    readonly property real pad: Math.max(tightPadding, Math.min(loosePadding, (span - endInset * 2 - content) / 2))
    readonly property real tileSpan: Math.ceil(content + pad * 2)

    function space(index) {
        return shrink ? share[index] : -1
    }
}
