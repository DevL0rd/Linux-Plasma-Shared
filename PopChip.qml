import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

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

    readonly property bool ringStyle: chipStyle === "ring" && fraction >= 0
    readonly property bool barStyle: chipStyle === "bar" && fraction >= 0
    readonly property real valueSize: Math.max(Kirigami.Theme.smallFont.pixelSize, Math.min(Kirigami.Theme.defaultFont.pixelSize * 1.05, panelThickness * (showLabel ? 0.34 : 0.42)))

    TextMetrics {
        id: valueMetrics
        font.pixelSize: chip.valueSize
        font.weight: Font.DemiBold
        font.features: { "tnum": 1 }
        text: chip.widestValue
    }
    TextMetrics {
        id: secondaryMetrics
        font.pixelSize: chip.valueSize * 0.78
        font.features: { "tnum": 1 }
        text: chip.widestSecondary
    }

    implicitWidth: vertical ? panelThickness : layout.implicitWidth
    implicitHeight: vertical ? layout.implicitHeight : panelThickness

    property real shownFraction: Math.max(0, Math.min(1, fraction))

    GridLayout {
        id: layout
        anchors.centerIn: parent
        flow: chip.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        columnSpacing: Kirigami.Units.smallSpacing
        rowSpacing: 1

        Kirigami.Icon {
            visible: chip.iconSource !== ""
            source: chip.iconSource
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: Math.round(chip.valueSize * 1.25)
            Layout.preferredHeight: Layout.preferredWidth
        }

        Item {
            visible: chip.ringStyle
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: Math.round(chip.valueSize * 1.5)
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

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 0

            PlasmaComponents.Label {
                visible: chip.showLabel && chip.label !== ""
                Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignLeft
                text: chip.label
                font.pixelSize: Math.max(8, chip.valueSize * 0.62)
                font.weight: Font.DemiBold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.4
                opacity: 0.6
            }

            GridLayout {
                Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignLeft
                flow: chip.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
                columnSpacing: Math.round(chip.valueSize * 0.3)
                rowSpacing: 0

                PlasmaComponents.Label {
                    visible: !chip.showLabel && chip.label !== "" && !chip.vertical
                    text: chip.label
                    font.pixelSize: chip.valueSize * 0.72
                    font.weight: Font.DemiBold
                    opacity: 0.55
                    Layout.alignment: Qt.AlignBaseline
                }
                PlasmaComponents.Label {
                    text: chip.value
                    color: chip.valueColor
                    horizontalAlignment: chip.vertical ? Text.AlignHCenter : Text.AlignRight
                    Layout.minimumWidth: chip.widestValue !== "" ? Math.ceil(valueMetrics.advanceWidth) : 0
                    font.pixelSize: chip.valueSize
                    font.weight: Font.DemiBold
                    font.features: { "tnum": 1 }
                    Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignBaseline
                }
                PlasmaComponents.Label {
                    visible: chip.secondary !== "" || chip.widestSecondary !== ""
                    text: chip.secondary
                    color: chip.secondaryColor
                    horizontalAlignment: chip.vertical ? Text.AlignHCenter : Text.AlignLeft
                    Layout.minimumWidth: chip.widestSecondary !== "" ? Math.ceil(secondaryMetrics.advanceWidth) : 0
                    font.pixelSize: chip.valueSize * 0.78
                    font.features: { "tnum": 1 }
                    opacity: 0.8
                    Layout.alignment: chip.vertical ? Qt.AlignHCenter : Qt.AlignBaseline
                }
            }

            Item {
                visible: chip.barStyle
                Layout.fillWidth: true
                Layout.topMargin: 2
                Layout.preferredHeight: 2
                Rectangle {
                    anchors.fill: parent
                    radius: 1
                    color: Qt.alpha(Kirigami.Theme.textColor, 0.14)
                }
                Rectangle {
                    height: parent.height
                    radius: 1
                    width: Math.round(parent.width * chip.shownFraction * Screen.devicePixelRatio) / Screen.devicePixelRatio
                    color: chip.barColor
                }
            }
        }
    }
}
