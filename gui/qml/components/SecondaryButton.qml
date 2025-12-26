import QtQuick
import QtQuick.Controls
import ".."

Rectangle {
    id: root
    
    property alias text: label.text
    property string icon: ""
    property bool enabled: true
    
    signal clicked()
    
    width: implicitWidth
    height: 40
    implicitWidth: contentRow.implicitWidth + Theme.spacingMd * 2
    radius: Theme.radiusSm
    color: mouseArea.containsMouse && enabled ? Theme.elevated : "transparent"
    border.width: 2
    border.color: Theme.elevated
    
    opacity: enabled ? 1.0 : 0.5
    scale: mouseArea.pressed && enabled ? 0.97 : 1.0
    
    Behavior on color {
        ColorAnimation { duration: Theme.animFast }
    }
    
    Behavior on scale {
        NumberAnimation { duration: Theme.animFast }
    }
    
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: Theme.spacingSm
        
        Text {
            text: root.icon
            font.pixelSize: Theme.fontSizeSm
            visible: root.icon.length > 0
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            id: label
            font.pixelSize: Theme.fontSizeSm
            font.weight: Font.Medium
            color: Theme.textPrimary
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        
        onClicked: {
            if (root.enabled) {
                root.clicked()
            }
        }
    }
}
