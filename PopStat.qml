import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: stat

    property string label
    property string value
    property string unit
    property color color: Kirigami.Theme.textColor
    property int trend: 0
    property real scale: 1.3
    property int alignment: Qt.AlignLeft

    spacing: 0

    PlasmaComponents.Label {
        Layout.alignment: stat.alignment
        text: stat.label
        font.pointSize: Kirigami.Theme.smallFont.pointSize * 0.95
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 0.5
        opacity: 0.6
        elide: Text.ElideRight
        Layout.fillWidth: stat.alignment === Qt.AlignLeft
        horizontalAlignment: stat.alignment === Qt.AlignHCenter ? Text.AlignHCenter : Text.AlignLeft
    }
    RowLayout {
        Layout.alignment: stat.alignment
        spacing: 2
        PlasmaComponents.Label {
            id: valueLabel
            text: stat.value
            color: stat.color
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * stat.scale
            font.weight: Font.DemiBold
            font.features: { "tnum": 1 }
            Layout.alignment: Qt.AlignBaseline
            Behavior on color { ColorAnimation { duration: 280 } }
        }
        PlasmaComponents.Label {
            visible: stat.unit !== ""
            text: stat.unit
            font: Kirigami.Theme.smallFont
            opacity: 0.6
            Layout.alignment: Qt.AlignBaseline
        }
        Kirigami.Icon {
            visible: stat.trend !== 0
            source: stat.trend > 0 ? "go-up-symbolic" : "go-down-symbolic"
            Layout.preferredWidth: Kirigami.Units.iconSizes.small * 0.75
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignVCenter
            opacity: 0.6
        }
    }
}
