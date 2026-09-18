import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "PopStage.js" as Stage

Item {
    id: chip

    property string label
    property string value
    property color valueColor: Kirigami.Theme.textColor
    property string secondary
    property color secondaryColor: Kirigami.Theme.textColor
    property string iconSource
    property real fraction: -1
    property color barColor: Kirigami.Theme.highlightColor
    property string chipStyle: "bar"
    property bool vertical: false
    property bool showLabel: false
    property real panelThickness: Kirigami.Units.gridUnit * 2
    property string widestValue
    property string widestSecondary
    property real contentGap: -1

    property real fitSpace: -1
    property string minimumStage: "tiny"
    property string maximumStage: "full"
    property string lockedStage: ""
    property string cappedStage: ""
    property real stageHysteresis: Kirigami.Units.smallSpacing
    property bool adaptive: false

    readonly property bool ringStyle: chipStyle === "ring" && fraction >= 0
    readonly property bool barStyle: chipStyle === "bar" && fraction >= 0
    readonly property real minFont: Math.max(8, Math.round(Math.min(Kirigami.Theme.smallFont.pixelSize, Kirigami.Theme.defaultFont.pixelSize) * 0.85))
    readonly property real maxFont: Kirigami.Theme.defaultFont.pixelSize
    function fontFor(factor) {
        return Math.max(minFont, Math.min(maxFont, panelThickness * factor))
    }
    readonly property real barCandidate: fontFor(showLabel ? 0.34 : 0.52)
    readonly property real inlineSize: adaptive ? Math.max(8, Math.round(valueSize * 0.72)) : valueSize * 0.72
    readonly property real secondarySize: adaptive ? Math.max(8, Math.round(valueSize * 0.78)) : valueSize * 0.78
    readonly property real aboveSize: Math.max(8, adaptive ? Math.round(valueSize * 0.62) : valueSize * 0.62)
    readonly property bool roomForBar: barStyle && (!adaptive || vertical
                                       || panelThickness >= barCandidate * 1.36 + barThickness + Math.max(1, Math.round(barCandidate * 0.14)) + 2)
    readonly property real valueSize: !adaptive ? Math.max(Kirigami.Theme.smallFont.pixelSize, Math.min(Kirigami.Theme.defaultFont.pixelSize * 1.05, panelThickness * (showLabel ? 0.34 : 0.42)))
                                    : roomForBar ? barCandidate : fontFor(showLabel ? 0.34 : 0.62)

    readonly property bool leadIsIdentity: adaptive && iconSource !== "" && !ringStyle && !barStyle
    readonly property int floorIndex: ringStyle || barStyle || iconSource !== "" ? Stage.TINY : Stage.SMALL
    readonly property int ceilingIndex: Math.max(floorIndex, Stage.index(maximumStage))
    readonly property int lowIndex: Math.min(ceilingIndex, Math.max(floorIndex, Stage.index(minimumStage)))
    readonly property int lockIndex: lockedStage === "" ? -1 : Math.max(floorIndex, Stage.index(lockedStage))

    property int autoIndex: ceilingIndex
    readonly property int capIndex: cappedStage === "" ? Stage.FULL : Math.max(floorIndex, Stage.index(cappedStage))
    readonly property int fittedIndex: {
        if (fitSpace < 0)
            return ceilingIndex
        let picked = ceilingIndex
        while (picked > lowIndex && sizeAt(picked) > fitSpace + 0.5)
            picked--
        return picked
    }
    readonly property int stageIndex: lockIndex >= 0 ? lockIndex
                                    : Math.min(capIndex, adaptive ? fittedIndex
                                                                  : fitSpace < 0 ? ceilingIndex
                                                                                 : Math.min(ceilingIndex, Math.max(lowIndex, autoIndex)))
    readonly property string stage: Stage.name(stageIndex)
    readonly property string fullText: [label, value, secondary].filter(part => part !== "").join(" ")

    readonly property real gap: Kirigami.Units.smallSpacing
    readonly property real innerGap: contentGap >= 0 ? contentGap : Math.round(valueSize * 0.3)
    readonly property real iconLen: iconSource !== "" ? Math.round(valueSize * 1.25) : 0
    readonly property real ringLen: ringStyle ? Math.round(valueSize * 1.5) : 0
    readonly property real tinyBarLen: Math.max(3, Math.round(valueSize * 0.42))
    readonly property real tinyBarSpan: Math.round(valueSize * 1.15)

    readonly property real valueWidth: Math.ceil(valueMetrics.advanceWidth)
    readonly property real secondaryWidth: secondary !== "" || widestSecondary !== "" ? Math.ceil(secondaryMetrics.advanceWidth) : 0
    readonly property real inlineWidth: !showLabel && label !== "" && !vertical ? Math.ceil(inlineMetrics.advanceWidth) : 0
    readonly property real aboveWidth: showLabel && label !== "" ? Math.ceil(aboveMetrics.advanceWidth) : 0
    readonly property real leadWidth: iconLen + ringLen + (iconLen > 0 && ringLen > 0 ? gap : 0)
    readonly property real rowWidth: inlineWidth + (inlineWidth > 0 ? innerGap : 0) + valueWidth + (secondaryWidth > 0 ? innerGap + secondaryWidth : 0)

    readonly property real leadHeight: iconLen + ringLen + (iconLen > 0 && ringLen > 0 ? 1 : 0)
    readonly property real barThickness: adaptive ? Math.max(2, Math.round(barCandidate * 0.18)) : 2
    readonly property real barMargin: adaptive ? Math.max(1, Math.round(valueSize * 0.14)) : 2
    readonly property real barHeight: roomForBar ? barThickness + barMargin : 0
    readonly property real valueHeight: Math.ceil(valueMetrics.height)
    readonly property real secondaryHeight: secondaryWidth > 0 ? Math.ceil(secondaryMetrics.height) : 0
    readonly property real aboveHeight: aboveWidth > 0 ? Math.ceil(aboveMetrics.height) : 0

    readonly property real sizeTiny: ringLen > 0 ? ringLen : barStyle ? tinyBarLen : iconLen
    readonly property real smallTail: adaptive ? Math.max(3, barHeight) : 3
    readonly property real sizeSmall: vertical ? (leadIsIdentity ? leadHeight + 1 : 0) + valueHeight + smallTail
                                               : (leadIsIdentity ? leadWidth + gap : 0) + valueWidth + 3
    readonly property real sizeMedium: vertical ? leadHeight + (leadHeight > 0 ? 1 : 0) + valueHeight + barHeight + 2
                                               : leadWidth + (leadWidth > 0 ? gap : 0) + valueWidth + 2
    readonly property real sizeFull: vertical ? leadHeight + (leadHeight > 0 ? 1 : 0) + aboveHeight + valueHeight + secondaryHeight + barHeight + 2
                                              : leadWidth + (leadWidth > 0 ? gap : 0) + Math.max(aboveWidth, rowWidth) + 2

    readonly property int lowestIndex: lockIndex >= 0 ? lockIndex : lowIndex
    readonly property int highestIndex: lockIndex >= 0 ? lockIndex : ceilingIndex
    readonly property real minimumSize: sizeAt(lowestIndex)
    readonly property real preferredSize: sizeAt(highestIndex)
    readonly property var stageSizes: [sizeTiny, sizeSmall, sizeMedium, sizeFull]
    readonly property var stageSpan: ({
        min: visible ? minimumSize : 0,
        max: visible ? preferredSize : 0,
        sizes: stageSizes,
        low: lowestIndex,
        high: highestIndex
    })

    readonly property bool atFull: stageIndex === Stage.FULL
    readonly property bool showsValue: stageIndex >= Stage.SMALL
    readonly property bool showsLead: stageIndex >= Stage.MEDIUM || (leadIsIdentity && showsValue)
    readonly property bool showsTinyBar: barStyle && ringLen === 0 && stageIndex === Stage.TINY

    readonly property var fitInputs: [fitSpace, sizeTiny, sizeSmall, sizeMedium, sizeFull, lowIndex, ceilingIndex]
    onFitInputsChanged: refit()

    function sizeAt(index) {
        switch (index) {
        case Stage.TINY: return sizeTiny
        case Stage.SMALL: return sizeSmall
        case Stage.MEDIUM: return sizeMedium
        default: return sizeFull
        }
    }

    function refit() {
        if (fitSpace < 0)
            return
        let picked = Math.min(ceilingIndex, Math.max(lowIndex, autoIndex))
        while (picked > lowIndex && sizeAt(picked) > fitSpace + stageHysteresis)
            picked--
        while (picked < ceilingIndex && sizeAt(picked + 1) <= fitSpace)
            picked++
        autoIndex = picked
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: chip.fullText

    TextMetrics {
        id: valueMetrics
        font.pixelSize: chip.valueSize
        font.weight: Font.DemiBold
        font.features: { "tnum": 1 }
        text: chip.widestValue !== "" ? chip.widestValue : chip.value
    }
    TextMetrics {
        id: secondaryMetrics
        font.pixelSize: chip.secondarySize
        font.features: { "tnum": 1 }
        text: chip.widestSecondary !== "" ? chip.widestSecondary : chip.secondary
    }
    TextMetrics {
        id: inlineMetrics
        font.pixelSize: chip.inlineSize
        font.weight: Font.DemiBold
        text: chip.label
    }
    TextMetrics {
        id: aboveMetrics
        font.pixelSize: chip.aboveSize
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 0.4
        text: chip.label
    }

    implicitWidth: vertical ? panelThickness : layout.implicitWidth
    implicitHeight: vertical ? layout.implicitHeight : panelThickness
    Layout.preferredWidth: !vertical && fitSpace >= 0 ? fitSpace : -1
    Layout.preferredHeight: vertical && fitSpace >= 0 ? fitSpace : -1

    property real shownFraction: Math.max(0, Math.min(1, fraction))

    GridLayout {
        id: layout
        anchors.centerIn: parent
        flow: chip.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        columnSpacing: Kirigami.Units.smallSpacing
        rowSpacing: 1

        Kirigami.Icon {
            visible: chip.iconSource !== "" && (chip.showsLead || (chip.stageIndex === Stage.TINY && chip.ringLen === 0 && !chip.barStyle))
            source: chip.iconSource
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: chip.iconLen
            Layout.preferredHeight: Layout.preferredWidth
        }

        Item {
            visible: chip.ringStyle && chip.stageIndex !== Stage.SMALL
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: chip.ringLen
            Layout.preferredHeight: Layout.preferredWidth
            Shape {
                id: miniRing
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                readonly property real thickness: Math.max(2, width * 0.16)
                readonly property real radius: (width - thickness) / 2
                ShapePath {
                    strokeColor: Qt.alpha(Kirigami.Theme.textColor, 0.15)
                    strokeWidth: miniRing.thickness
                    fillColor: "transparent"
                    PathAngleArc { centerX: miniRing.width / 2; centerY: miniRing.height / 2; radiusX: miniRing.radius; radiusY: miniRing.radius; startAngle: -90; sweepAngle: 360 }
                }
                ShapePath {
                    strokeColor: chip.barColor
                    strokeWidth: miniRing.thickness
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    PathAngleArc { centerX: miniRing.width / 2; centerY: miniRing.height / 2; radiusX: miniRing.radius; radiusY: miniRing.radius; startAngle: -90; sweepAngle: Math.max(1, Math.round(360 * chip.shownFraction)) }
                }
            }
        }

        Item {
            visible: chip.showsTinyBar
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: chip.vertical ? chip.tinyBarSpan : chip.tinyBarLen
            Layout.preferredHeight: chip.vertical ? chip.tinyBarLen : chip.tinyBarSpan
            Rectangle {
                anchors.fill: parent
                radius: Math.min(width, height) / 2
                color: Qt.alpha(Kirigami.Theme.textColor, 0.14)
            }
            Rectangle {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: chip.vertical ? Math.round(parent.width * chip.shownFraction) : parent.width
                height: chip.vertical ? parent.height : Math.max(chip.tinyBarLen, Math.round(parent.height * chip.shownFraction))
                radius: Math.min(parent.width, parent.height) / 2
                color: chip.barColor
            }
        }

        ColumnLayout {
            visible: chip.showsValue
            Layout.alignment: Qt.AlignCenter
            spacing: 0

            PlasmaComponents.Label {
                visible: chip.showLabel && chip.label !== "" && chip.atFull
                Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignLeft
                text: chip.label
                font.pixelSize: chip.aboveSize
                font.weight: Font.DemiBold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.4
                opacity: 0.6
            }

            GridLayout {
                Layout.alignment: chip.vertical || !chip.atFull ? Qt.AlignHCenter : Qt.AlignLeft
                flow: chip.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
                columnSpacing: chip.innerGap
                rowSpacing: 0

                PlasmaComponents.Label {
                    visible: !chip.showLabel && chip.label !== "" && !chip.vertical && chip.atFull
                    text: chip.label
                    font.pixelSize: chip.inlineSize
                    font.weight: Font.DemiBold
                    opacity: 0.55
                    Layout.alignment: Qt.AlignBaseline
                }
                PlasmaComponents.Label {
                    visible: chip.showsValue
                    text: chip.value
                    color: chip.valueColor
                    horizontalAlignment: chip.vertical || (chip.adaptive && chip.fraction >= 0 && !chip.atFull) ? Text.AlignHCenter : Text.AlignRight
                    Layout.minimumWidth: chip.widestValue !== "" ? Math.ceil(valueMetrics.advanceWidth) : 0
                    font.pixelSize: chip.valueSize
                    font.weight: Font.DemiBold
                    font.features: { "tnum": 1 }
                    Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignBaseline
                }
                PlasmaComponents.Label {
                    visible: (chip.secondary !== "" || chip.widestSecondary !== "") && chip.atFull
                    text: chip.secondary
                    color: chip.secondaryColor
                    horizontalAlignment: chip.vertical ? Text.AlignHCenter : Text.AlignLeft
                    Layout.minimumWidth: chip.widestSecondary !== "" ? Math.ceil(secondaryMetrics.advanceWidth) : 0
                    font.pixelSize: chip.secondarySize
                    font.features: { "tnum": 1 }
                    opacity: 0.8
                    Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignBaseline
                }
            }

            Item {
                visible: chip.adaptive ? chip.roomForBar && chip.showsValue : chip.barStyle && chip.showsValue
                Layout.fillWidth: true
                Layout.topMargin: chip.barMargin
                Layout.preferredHeight: chip.barThickness
                Rectangle {
                    anchors.fill: parent
                    radius: chip.adaptive ? height / 2 : 1
                    color: Qt.alpha(Kirigami.Theme.textColor, 0.14)
                }
                Rectangle {
                    height: parent.height
                    radius: chip.adaptive ? height / 2 : 1
                    width: chip.adaptive && chip.shownFraction <= 0 ? 0
                         : Math.max(chip.adaptive ? parent.height : 0,
                                    Math.round(parent.width * chip.shownFraction * Screen.devicePixelRatio) / Screen.devicePixelRatio)
                    color: chip.barColor
                }
            }
        }
    }
}
