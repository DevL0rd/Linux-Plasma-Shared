import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Flow {
    id: actions

    property var model: []
    property bool showText: true

    Layout.fillWidth: true
    spacing: Kirigami.Units.smallSpacing

    Repeater {
        model: actions.model

        PlasmaComponents.ToolButton {
            required property var modelData
            visible: modelData.visible === undefined || modelData.visible
            text: modelData.text
            icon.name: modelData.icon
            icon.color: modelData.destructive ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
            display: actions.showText ? PlasmaComponents.AbstractButton.TextBesideIcon : PlasmaComponents.AbstractButton.IconOnly
            onClicked: modelData.run()
            QQC2.ToolTip.visible: !actions.showText && hovered
            QQC2.ToolTip.text: modelData.text
            QQC2.ToolTip.delay: 400
        }
    }
}
