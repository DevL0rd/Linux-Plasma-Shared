import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Rectangle {
    id: card

    property string title
    property string icon
    property string trailing
    property color trailingColor: Kirigami.Theme.textColor
    property bool collapsible: false
    property bool collapsed: false
    signal collapseToggled()
    default property alias content: body.data
    readonly property real pad: Kirigami.Units.smallSpacing * 2.5

    function flash() { flashAnimation.restart() }

    Layout.fillWidth: true
    radius: Kirigami.Units.cornerRadius * 2
    color: Qt.alpha(Kirigami.Theme.textColor, 0.045)
    border.width: 1
    border.color: Qt.alpha(Kirigami.Theme.textColor, 0.07)
    implicitHeight: column.implicitHeight + pad * 2

    Rectangle {
        id: flashRing
        anchors.fill: parent
        radius: parent.radius
        color: Qt.alpha(Kirigami.Theme.highlightColor, 0.08)
        border.width: 1.5
        border.color: Kirigami.Theme.highlightColor
        opacity: 0
        SequentialAnimation {
            id: flashAnimation
            NumberAnimation { target: flashRing; property: "opacity"; to: 1; duration: 160; easing.type: Easing.OutCubic }
            PauseAnimation { duration: 380 }
            NumberAnimation { target: flashRing; property: "opacity"; to: 0; duration: 520; easing.type: Easing.InOutCubic }
        }
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: card.pad
        spacing: Kirigami.Units.smallSpacing * 2

        RowLayout {
            Layout.fillWidth: true
            visible: card.title !== "" || card.trailing !== ""
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                visible: card.icon !== ""
                source: card.icon
                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                opacity: 0.7
            }
            PlasmaComponents.Label {
                text: card.title
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                font.weight: Font.DemiBold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.6
                opacity: 0.65
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                visible: card.trailing !== ""
                text: card.trailing
                color: card.trailingColor
                font.weight: Font.Bold
                font.features: { "tnum": 1 }
            }
            PlasmaComponents.ToolButton {
                visible: card.collapsible
                icon.name: card.collapsed ? "arrow-down" : "arrow-up"
                display: PlasmaComponents.AbstractButton.IconOnly
                implicitWidth: Kirigami.Units.iconSizes.small + Kirigami.Units.smallSpacing * 2
                implicitHeight: implicitWidth
                onClicked: card.collapseToggled()
            }
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            visible: !card.collapsed
            spacing: Kirigami.Units.smallSpacing * 2
        }
    }
}
