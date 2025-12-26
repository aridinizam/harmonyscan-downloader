import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Popup {
    id: root
    
    property string errorMessage: ""
    
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    width: 400
    height: contentColumn.implicitHeight + Theme.spacingLg * 2
    
    background: Rectangle {
        color: Theme.cardBg
        radius: Theme.radiusLg
        border.width: 2
        border.color: Theme.error
        
        // Glow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            radius: parent.radius + 4
            color: "transparent"
            border.width: 2
            border.color: Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.3)
        }
    }
    
    // Fade animation
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animNormal }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: Theme.animNormal; easing.type: Easing.OutBack }
    }
    
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.animFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.9; duration: Theme.animFast }
    }
    
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: Theme.spacingLg
        spacing: Theme.spacingMd
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            
            Text {
                text: "⚠️"
                font.pixelSize: 24
            }
            
            Text {
                text: "Error"
                font.pixelSize: Theme.fontSizeLg
                font.bold: true
                color: Theme.error
            }
            
            Item { Layout.fillWidth: true }
            
            // Close button
            Rectangle {
                width: 28
                height: 28
                radius: Theme.radiusFull
                color: closeMouseArea.containsMouse ? Theme.elevated : "transparent"
                
                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: Theme.fontSizeSm
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }
        
        // Error message
        Text {
            Layout.fillWidth: true
            text: root.errorMessage
            font.pixelSize: Theme.fontSizeMd
            color: Theme.textSecondary
            wrapMode: Text.WordWrap
        }
        
        // OK button
        PrimaryButton {
            Layout.alignment: Qt.AlignRight
            text: "OK"
            onClicked: root.close()
        }
    }
}
