import QtQuick
import QtQuick.Controls
import ".."

Rectangle {
    id: root
    
    property alias text: label.text
    property string icon: ""
    property bool enabled: true
    property bool loading: false
    
    signal clicked()
    
    width: implicitWidth
    height: 44
    implicitWidth: contentRow.implicitWidth + Theme.spacingLg * 2
    radius: Theme.radiusSm
    
    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { 
            position: 0.0
            color: enabled && mouseArea.containsMouse 
                ? Qt.lighter(Theme.accent, 1.1) 
                : Theme.accent 
        }
        GradientStop { 
            position: 1.0
            color: enabled && mouseArea.containsMouse 
                ? Qt.lighter(Theme.accentSecondary, 1.1) 
                : Theme.accentSecondary 
        }
    }
    
    opacity: enabled ? 1.0 : 0.5
    scale: mouseArea.pressed && enabled ? 0.97 : (mouseArea.containsMouse && enabled ? 1.02 : 1.0)
    
    Behavior on scale {
        NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutQuad }
    }
    
    Behavior on opacity {
        NumberAnimation { duration: Theme.animNormal }
    }
    
    // Glow effect
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: parent.radius + 3
        color: "transparent"
        border.width: mouseArea.containsMouse && enabled ? 2 : 0
        border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.4)
        
        Behavior on border.width {
            NumberAnimation { duration: Theme.animFast }
        }
    }
    
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: Theme.spacingSm
        
        Text {
            text: root.icon
            font.pixelSize: Theme.fontSizeMd
            visible: root.icon.length > 0 && !root.loading
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Loading spinner
        Text {
            text: "⏳"
            font.pixelSize: Theme.fontSizeMd
            visible: root.loading
            anchors.verticalCenter: parent.verticalCenter
            
            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 1500
                loops: Animation.Infinite
                running: root.loading
            }
        }
        
        Text {
            id: label
            font.pixelSize: Theme.fontSizeMd
            font.bold: true
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
            if (root.enabled && !root.loading) {
                root.clicked()
            }
        }
    }
}
