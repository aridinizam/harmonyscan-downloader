import QtQuick
import QtQuick.Controls
import ".."

Item {
    id: root
    
    property real value: 0  // 0.0 to 1.0
    property string label: ""
    property string status: ""
    property bool animated: true
    
    height: 32
    
    // Background
    Rectangle {
        id: background
        anchors.fill: parent
        radius: Theme.radiusMd
        color: Theme.secondaryBg
        
        // Fill bar
        Rectangle {
            id: fill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * root.value
            radius: parent.radius
            
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.accent }
                GradientStop { position: 1.0; color: Theme.accentSecondary }
            }
            
            Behavior on width {
                enabled: root.animated
                NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutQuad }
            }
            
            // Animated gradient shine
            Rectangle {
                id: shine
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 60
                radius: parent.radius
                opacity: 0.3
                
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: "white" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                
                visible: root.value > 0 && root.value < 1
                
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: shine.visible
                    
                    PropertyAnimation {
                        from: -shine.width
                        to: fill.width
                        duration: 1500
                        easing.type: Easing.Linear
                    }
                    
                    PauseAnimation { duration: 500 }
                }
            }
            
            // Glow effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: parent.radius + 2
                color: "transparent"
                border.width: 2
                border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.3)
                visible: root.value > 0 && root.value < 1
            }
        }
        
        // Center text
        Row {
            anchors.centerIn: parent
            spacing: Theme.spacingSm
            
            Text {
                text: root.label
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Medium
                color: Theme.textPrimary
                visible: root.label.length > 0
            }
            
            Text {
                text: Math.round(root.value * 100) + "%"
                font.pixelSize: Theme.fontSizeSm
                font.bold: true
                color: Theme.textPrimary
            }
            
            Text {
                text: root.status
                font.pixelSize: Theme.fontSizeSm
                color: Theme.textSecondary
                visible: root.status.length > 0
            }
        }
    }
}
