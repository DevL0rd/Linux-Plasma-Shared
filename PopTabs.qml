import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Item {
    id: tabs

    property var model: []
    property int currentIndex: 0
    signal activated(int index)

    readonly property Item currentItem: repeater.count > currentIndex ? repeater.itemAt(currentIndex) : null

    implicitHeight: row.implicitHeight + 6
    Layout.fillWidth: true

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Qt.alpha(Kirigami.Theme.textColor, 0.06)
    }

    Rectangle {
        visible: tabs.currentItem !== null
        x: row.x + (tabs.currentItem ? tabs.currentItem.x : 0)
        y: row.y
        width: tabs.currentItem ? tabs.currentItem.width : 0
        height: row.height
        radius: height / 2
        color: Qt.alpha(Kirigami.Theme.highlightColor, 0.24)
        border.width: 1
        border.color: Qt.alpha(Kirigami.Theme.highlightColor, 0.5)
        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 3
        spacing: 0

        Repeater {
            id: repeater
            model: tabs.model

            MouseArea {
                id: tab
                required property int index
                required property var modelData
                readonly property bool current: index === tabs.currentIndex

                Layout.fillWidth: true
                Layout.preferredWidth: content.implicitWidth + Kirigami.Units.smallSpacing * 3
                implicitHeight: content.implicitHeight + Kirigami.Units.smallSpacing * 1.6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    tabs.currentIndex = index
                    tabs.activated(index)
                }

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Qt.alpha(Kirigami.Theme.textColor, 0.06)
                    opacity: tab.containsMouse && !tab.current ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 120 } }
                }

                Row {
                    id: content
                    anchors.centerIn: parent
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        visible: !!tab.modelData.icon
                        source: tab.modelData.icon || ""
                        width: Kirigami.Units.iconSizes.small
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    PlasmaComponents.Label {
                        text: tab.modelData.label
                        font.weight: tab.current ? Font.DemiBold : Font.Normal
                        opacity: tab.current ? 1 : 0.75
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        visible: tab.modelData.badge !== undefined && tab.modelData.badge !== ""
                        anchors.verticalCenter: parent.verticalCenter
                        height: badgeLabel.implicitHeight
                        width: Math.max(height, badgeLabel.implicitWidth + Kirigami.Units.smallSpacing * 2)
                        radius: height / 2
                        color: Qt.alpha(Kirigami.Theme.textColor, tab.current ? 0.16 : 0.1)
                        PlasmaComponents.Label {
                            id: badgeLabel
                            anchors.centerIn: parent
                            text: tab.modelData.badge === undefined ? "" : tab.modelData.badge
                            font.pointSize: Kirigami.Theme.smallFont.pointSize * 0.9
                            font.features: { "tnum": 1 }
                        }
                    }
                }
            }
        }
    }
}
