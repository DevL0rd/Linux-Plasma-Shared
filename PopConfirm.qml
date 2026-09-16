import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.Button {
    id: button

    property string label
    property string iconName
    property string confirmText: i18n("Click again to confirm")
    property bool armed: false
    property real remaining: 1
    signal confirmed()

    text: armed ? confirmText : label
    icon.name: armed ? "dialog-warning" : iconName
    icon.color: armed ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
    palette.buttonText: armed ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor

    onClicked: {
        if (armed) {
            drain.stop()
            armed = false
            confirmed()
        } else {
            armed = true
            drain.restart()
        }
    }

    NumberAnimation {
        id: drain
        target: button
        property: "remaining"
        from: 1
        to: 0
        duration: 4000
        onFinished: button.armed = false
    }

    Rectangle {
        visible: button.armed
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 3
        height: 2
        radius: 1
        width: (parent.width - 6) * button.remaining
        color: Kirigami.Theme.negativeTextColor
    }
}
