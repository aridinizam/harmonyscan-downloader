import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    
    property var window: null
    
    color: "transparent"
    
    // Gradient background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Theme.primaryBg }
            GradientStop { position: 1.0; color: Theme.secondaryBg }
        }
    }
    
    // Drag area for moving window
    MouseArea {
        id: dragArea
        anchors.fill: parent
        anchors.rightMargin: 120
        
        property point clickPos: Qt.point(0, 0)
        
        onPressed: function(mouse) {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        
        onPositionChanged: function(mouse) {
            if (pressed && window) {
                window.x += mouse.x - clickPos.x
                window.y += mouse.y - clickPos.y
            }
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingSm
        spacing: Theme.spacingSm
        
        // Logo
        Rectangle {
            width: 28
            height: 28
            radius: Theme.radiusSm
            color: Theme.accent
            
            Text {
                anchors.centerIn: parent
                text: "📖"
                font.pixelSize: 16
            }
            
            // Subtle animation
            SequentialAnimation on rotation {
                loops: Animation.Infinite
                running: true
                NumberAnimation { to: 5; duration: 1500; easing.type: Easing.InOutQuad }
                NumberAnimation { to: -5; duration: 1500; easing.type: Easing.InOutQuad }
            }
        }
        
        // Title
        Text {
            text: "HarmonyScan Downloader"
            font.pixelSize: Theme.fontSizeMd
            font.bold: true
            color: Theme.textPrimary
            Layout.fillWidth: true
        }
        
        // Settings button
        TitleBarButton {
            icon: "⚙"
            onClicked: settingsDialog.open()
            ToolTip.visible: hovered
            ToolTip.text: "Settings"
        }
        
        // Minimize button
        TitleBarButton {
            icon: "─"
            onClicked: window.showMinimized()
            ToolTip.visible: hovered
            ToolTip.text: "Minimize"
        }
        
        // Maximize button
        TitleBarButton {
            icon: window && window.visibility === Window.Maximized ? "❐" : "□"
            onClicked: {
                if (window.visibility === Window.Maximized) {
                    window.showNormal()
                } else {
                    window.showMaximized()
                }
            }
            ToolTip.visible: hovered
            ToolTip.text: window && window.visibility === Window.Maximized ? "Restore" : "Maximize"
        }
        
        // Close button
        TitleBarButton {
            icon: "✕"
            isClose: true
            onClicked: Qt.quit()
            ToolTip.visible: hovered
            ToolTip.text: "Close"
        }
    }
    
    // Bottom border accent
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Theme.accent }
            GradientStop { position: 0.5; color: Theme.accentSecondary }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
    
    // Title bar button component
    component TitleBarButton: Rectangle {
        property string icon: ""
        property bool isClose: false
        property bool hovered: mouseArea.containsMouse
        
        signal clicked()
        
        width: 40
        height: 28
        radius: Theme.radiusSm
        color: mouseArea.containsMouse 
            ? (isClose ? Theme.error : Theme.elevated)
            : "transparent"
        
        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }
        
        Text {
            anchors.centerIn: parent
            text: parent.icon
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textPrimary
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }
}
