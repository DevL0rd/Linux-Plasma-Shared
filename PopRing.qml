import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    id: ring

    property real value: 0
    property string text: Math.round(value) + ""
    property string unit: "%"
    property string label
    property string caption
    property color color: Kirigami.Theme.highlightColor
    property real diameter: Kirigami.Units.gridUnit * 4.6
    signal clicked()

    property real shown: Math.max(0, Math.min(100, value))

    spacing: Kirigami.Units.smallSpacing

    Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: ring.diameter
        Layout.preferredHeight: ring.diameter

        Shape {
            id: arc
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            readonly property real thickness: Math.max(4, ring.diameter * 0.075)
            readonly property real radius: (ring.diameter - thickness) / 2

            ShapePath {
                strokeColor: Qt.alpha(Kirigami.Theme.textColor, 0.1)
                strokeWidth: arc.thickness
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: ring.diameter / 2
                    centerY: ring.diameter / 2
                    radiusX: arc.radius
                    radiusY: arc.radius
                    startAngle: 135
                    sweepAngle: 270
                }
            }
            ShapePath {
                strokeColor: ring.color
                strokeWidth: arc.thickness
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: ring.diameter / 2
                    centerY: ring.diameter / 2
                    radiusX: arc.radius
                    radiusY: arc.radius
                    startAngle: 135
                    sweepAngle: Math.max(0.5, Math.round(540 * ring.shown / 100) / 2)
                }
            }
        }

        Row {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -ring.diameter * 0.02
            spacing: 1
            PlasmaComponents.Label {
                id: ringValue
                text: ring.text
                font.pixelSize: ring.diameter * 0.27
                font.weight: Font.DemiBold
                font.features: { "tnum": 1 }
                color: ring.color
            }
            PlasmaComponents.Label {
                text: ring.unit
                font.pixelSize: ring.diameter * 0.13
                opacity: 0.6
                anchors.baseline: ringValue.baseline
            }
        }

        PlasmaComponents.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ring.diameter * 0.04
            text: ring.label
            font.pixelSize: ring.diameter * 0.11
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.6
            opacity: 0.6
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: ring.clicked()
        }
    }

    PlasmaComponents.Label {
        visible: ring.caption !== ""
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: ring.diameter * 1.5
        text: ring.caption
        font: Kirigami.Theme.smallFont
        opacity: 0.7
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }
}
