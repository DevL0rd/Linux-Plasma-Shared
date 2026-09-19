import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: tile

    property bool vertical: false
    property real inset: 2
    property real endInset: inset
    property real span: 0
    property bool lit: false
    property bool customBackground: false
    property color backgroundColor: "transparent"
    property real backgroundOpacity: 1

    readonly property real across: vertical ? Math.max(0, parent.width - inset * 2)
                                            : Math.max(0, parent.height - inset * 2)
    readonly property real along: Math.max(0, Math.min(vertical ? parent.height - endInset * 2
                                                                : parent.width - endInset * 2, span))

    anchors.centerIn: parent
    width: vertical ? across : along
    height: vertical ? along : across
    radius: Math.min(Kirigami.Units.cornerRadius * 2, Math.min(width, height) / 2)
    color: customBackground ? Qt.alpha(backgroundColor, backgroundOpacity) : "transparent"
    gradient: customBackground ? null : defaultGradient

    Gradient {
        id: defaultGradient
        orientation: tile.vertical ? Gradient.Horizontal : Gradient.Vertical
        GradientStop { position: 0; color: Qt.alpha(Kirigami.Theme.textColor, tile.lit ? 0.16 : 0.10) }
        GradientStop { position: 1; color: Qt.alpha(Kirigami.Theme.textColor, tile.lit ? 0.09 : 0.04) }
    }
}
