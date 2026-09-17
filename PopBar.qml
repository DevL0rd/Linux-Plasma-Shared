import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: bar

    property string label
    property string valueText: Math.round(value) + "%"
    property real value: 0
    property real peak: -1
    property color color: Kirigami.Theme.highlightColor
    property real thickness: Kirigami.Units.smallSpacing * 1.5
    property string tooltip: (label ? label + ": " : "") + valueText

    spacing: Kirigami.Units.smallSpacing

    RowLayout {
        Layout.fillWidth: true
        visible: bar.label !== "" || bar.valueText !== ""
        PlasmaComponents.Label {
            text: bar.label
            font: Kirigami.Theme.smallFont
            opacity: 0.75
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
        PlasmaComponents.Label {
            text: bar.valueText
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            font.weight: Font.DemiBold
            font.features: { "tnum": 1 }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: bar.thickness

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Qt.alpha(Kirigami.Theme.textColor, 0.1)
        }
        Rectangle {
            height: parent.height
            radius: height / 2
            width: Math.max(height, Math.round(parent.width * Math.max(0, Math.min(1, bar.value / 100)) * Screen.devicePixelRatio) / Screen.devicePixelRatio)
            opacity: bar.value > 0 ? 1 : 0
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Qt.alpha(bar.color, 0.55) }
                GradientStop { position: 1; color: bar.color }
            }
        }
        Rectangle {
            visible: bar.peak > bar.value + 1
            width: 2
            height: parent.height + 2
            y: -1
            radius: 1
            x: Math.max(0, Math.min(parent.width - width, parent.width * bar.peak / 100))
            color: Qt.alpha(bar.color, 0.55)
        }
    }

    HoverHandler { id: hover }
    QQC2.ToolTip.visible: hover.hovered && bar.tooltip !== ""
    QQC2.ToolTip.text: bar.tooltip
    QQC2.ToolTip.delay: 400
}
