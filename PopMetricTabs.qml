import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "History.js" as History

ColumnLayout {
    id: metricTabs

    property var metrics: []
    property var source: ({})
    property var valuesFor: function(key) { return [] }
    property int tick: 0
    property int selected: 0
    property bool chartVisible: true
    property real chartHeight: Kirigami.Units.gridUnit * 3.6
    property string extraStats
    signal userSelected(int index)

    readonly property var current: metrics[selected] || ({})
    readonly property var series: { tick; selected; return current.key ? valuesFor(current.key) : [] }
    readonly property var stats: History.stats(series)

    function format(v) { return current.fmt ? current.fmt(v) : Math.round(v) + "" }

    Layout.fillWidth: true
    spacing: Kirigami.Units.smallSpacing * 1.5

    Sparkline {
        visible: metricTabs.chartVisible
        Layout.fillWidth: true
        Layout.preferredHeight: metricTabs.chartHeight
        values: metricTabs.series
        rangeMax: metricTabs.current.max ? metricTabs.current.max(metricTabs.source) : 0
        dangerFrom: metricTabs.current.crit !== undefined ? metricTabs.current.crit : -1
        tipText: function(v) { return metricTabs.format(v) }
    }

    RowLayout {
        visible: metricTabs.chartVisible && metricTabs.stats.count > 0
        Layout.fillWidth: true
        spacing: Kirigami.Units.largeSpacing
        Repeater {
            model: [
                { label: i18n("Now"), value: metricTabs.stats.now },
                { label: i18n("Peak"), value: metricTabs.stats.peak },
                { label: i18n("Avg"), value: metricTabs.stats.avg }
            ]
            RowLayout {
                required property var modelData
                spacing: Kirigami.Units.smallSpacing
                PlasmaComponents.Label {
                    text: modelData.label
                    font: Kirigami.Theme.smallFont
                    opacity: 0.55
                }
                PlasmaComponents.Label {
                    text: metricTabs.format(modelData.value)
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    font.weight: Font.DemiBold
                    font.features: { "tnum": 1 }
                    opacity: 0.85
                }
            }
        }
        Item { Layout.fillWidth: true }
        PlasmaComponents.Label {
            visible: metricTabs.extraStats !== ""
            text: metricTabs.extraStats
            font: Kirigami.Theme.smallFont
            opacity: 0.55
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Repeater {
            model: metricTabs.metrics

            MouseArea {
                id: tab
                required property int index
                required property var modelData
                readonly property bool current: index === metricTabs.selected
                readonly property real value: modelData.get(metricTabs.source)

                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: tabColumn.implicitHeight + Kirigami.Units.smallSpacing * 1.6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    metricTabs.selected = index
                    metricTabs.userSelected(index)
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Kirigami.Units.cornerRadius
                    color: tab.current ? Qt.alpha(Kirigami.Theme.highlightColor, 0.2)
                         : tab.containsMouse ? Qt.alpha(Kirigami.Theme.textColor, 0.07) : "transparent"
                    border.width: tab.current ? 1 : 0
                    border.color: Qt.alpha(Kirigami.Theme.highlightColor, 0.45)
                    Behavior on color { ColorAnimation { duration: 160 } }
                }

                ColumnLayout {
                    id: tabColumn
                    anchors.centerIn: parent
                    width: parent.width - Kirigami.Units.smallSpacing
                    spacing: 0
                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: tab.modelData.label
                        font.pointSize: Kirigami.Theme.smallFont.pointSize * 0.95
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 0.4
                        opacity: tab.current ? 0.85 : 0.55
                        elide: Text.ElideRight
                    }
                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: tab.modelData.fmt(tab.value)
                        color: tab.modelData.color ? tab.modelData.color(tab.value) : Kirigami.Theme.textColor
                        font.weight: Font.DemiBold
                        font.features: { "tnum": 1 }
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
