import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras

FocusScope {
    id: shell

    property string icon
    property string title
    property string subtitle
    property color statusColor: Kirigami.Theme.positiveTextColor
    property bool statusVisible: true
    property string statusText
    property alias searchText: searchField.text
    property string searchPlaceholder: i18n("Search…")
    property int matchCount: -1
    property var tabs: []
    property int currentTab: 0
    property bool showTabs: tabs.length > 0 && searchText === ""
    property alias headerExtra: extraRow.data
    property alias headerActions: actionRow.data
    default property alias content: body.data
    signal searchNext()
    signal searchPrevious()
    signal searchAccepted()
    signal tabActivated(int index)
    signal closeRequested()

    function pulse() { pulseAnimation.restart() }
    function focusSearch() { searchField.forceActiveFocus() }
    function clearSearch() { searchField.text = "" }

    Keys.onEscapePressed: function(event) {
        if (searchField.text !== "") {
            searchField.text = ""
        } else {
            shell.closeRequested()
        }
        event.accepted = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing

            Item {
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                Kirigami.Icon {
                    anchors.fill: parent
                    source: shell.icon
                }
                Rectangle {
                    id: statusDot
                    visible: shell.statusVisible
                    width: Math.round(Kirigami.Units.iconSizes.medium * 0.34)
                    height: width
                    radius: width / 2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: -2
                    color: shell.statusColor
                    border.width: 2
                    border.color: Kirigami.Theme.backgroundColor
                    Behavior on color { ColorAnimation { duration: 280 } }
                    Rectangle {
                        id: pulseRing
                        anchors.centerIn: parent
                        width: parent.width
                        height: width
                        radius: width / 2
                        color: "transparent"
                        border.width: 1.5
                        border.color: shell.statusColor
                        opacity: 0
                        ParallelAnimation {
                            id: pulseAnimation
                            NumberAnimation { target: pulseRing; property: "scale"; from: 1; to: 2.4; duration: 700; easing.type: Easing.OutCubic }
                            NumberAnimation { target: pulseRing; property: "opacity"; from: 0.7; to: 0; duration: 700; easing.type: Easing.OutCubic }
                        }
                    }
                    HoverHandler { id: statusHover }
                    QQC2.ToolTip.visible: statusHover.hovered && shell.statusText !== ""
                    QQC2.ToolTip.text: shell.statusText
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Kirigami.Heading {
                    level: 3
                    text: shell.title
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                PlasmaComponents.Label {
                    visible: shell.subtitle !== ""
                    text: shell.subtitle
                    font: Kirigami.Theme.smallFont
                    opacity: 0.65
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                id: extraRow
                spacing: Kirigami.Units.smallSpacing
            }
            RowLayout {
                id: actionRow
                spacing: 0
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaExtras.SearchField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: shell.searchPlaceholder
                focus: true
                Keys.onDownPressed: shell.searchNext()
                Keys.onUpPressed: shell.searchPrevious()
                onAccepted: shell.searchAccepted()
                Keys.onEscapePressed: function(event) {
                    if (text !== "") {
                        text = ""
                    } else {
                        shell.closeRequested()
                    }
                    event.accepted = true
                }
            }
            PlasmaComponents.Label {
                visible: shell.searchText !== "" && shell.matchCount >= 0
                text: shell.matchCount === 0 ? i18n("No matches") : i18np("%1 match", "%1 matches", shell.matchCount)
                font: Kirigami.Theme.smallFont
                opacity: 0.6
            }
        }

        PopTabs {
            visible: shell.showTabs
            Layout.fillWidth: true
            model: shell.tabs
            currentIndex: shell.currentTab
            onActivated: function(index) {
                shell.currentTab = index
                shell.tabActivated(index)
            }
        }

        Item {
            id: body
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
