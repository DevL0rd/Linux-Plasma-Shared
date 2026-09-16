import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ScrollView {
    id: scroll

    default property alias content: column.data
    readonly property alias column: column

    function scrollTo(item) {
        if (!item) return
        const point = item.mapToItem(column, 0, 0)
        const flick = scroll.contentItem
        const target = Math.max(0, Math.min(point.y - Kirigami.Units.largeSpacing, column.height - flick.height))
        scrollAnimation.to = target
        scrollAnimation.restart()
    }

    contentWidth: availableWidth
    clip: true
    QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff

    NumberAnimation {
        id: scrollAnimation
        target: scroll.contentItem
        property: "contentY"
        duration: 260
        easing.type: Easing.OutCubic
    }

    ColumnLayout {
        id: column
        width: scroll.availableWidth
        spacing: Kirigami.Units.largeSpacing
    }
}
