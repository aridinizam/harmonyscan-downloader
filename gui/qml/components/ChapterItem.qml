import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    
    property string chapterTitle: ""
    property real chapterNumber: 0
    property int views: 0
    property bool selected: false
    
    signal toggled()
    
    height: 48
    radius: Theme.radiusSm
    color: mouseArea.containsMouse ? Theme.elevated : "transparent"
    border.width: selected ? 2 : 0
    border.color: Theme.accent
    
    Behavior on color {
        ColorAnimation { duration: Theme.animFast }
    }
    
    Behavior on border.width {
        NumberAnimation { duration: Theme.animFast }
    }
    
    // Left accent bar when selected
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        radius: 2
        color: Theme.accent
        visible: root.selected
        
        Behavior on visible {
            NumberAnimation { duration: Theme.animFast }
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingMd
        spacing: Theme.spacingMd
        
        // Checkbox
        Rectangle {
            width: 24
            height: 24
            radius: Theme.radiusSm
            color: root.selected ? Theme.accent : "transparent"
            border.width: 2
            border.color: root.selected ? Theme.accent : Theme.textMuted
            
            Behavior on color {
                ColorAnimation { duration: Theme.animFast }
            }
            
            Behavior on border.color {
                ColorAnimation { duration: Theme.animFast }
            }
            
            // Checkmark
            Text {
                anchors.centerIn: parent
                text: "✓"
                font.pixelSize: 14
                font.bold: true
                color: Theme.textPrimary
                opacity: root.selected ? 1 : 0
                scale: root.selected ? 1 : 0.5
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animFast }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutBack }
                }
            }
        }
        
        // Chapter title
        Text {
            Layout.fillWidth: true
            text: root.chapterTitle
            font.pixelSize: Theme.fontSizeSm
            font.weight: root.selected ? Font.Medium : Font.Normal
            color: root.selected ? Theme.textPrimary : Theme.textSecondary
            elide: Text.ElideRight
            
            Behavior on color {
                ColorAnimation { duration: Theme.animFast }
            }
        }
        
        // Views badge
        Rectangle {
            visible: root.views > 0
            width: viewsText.implicitWidth + Theme.spacingSm * 2
            height: viewsText.implicitHeight + Theme.spacingXs
            radius: Theme.radiusFull
            color: Theme.secondaryBg
            
            Text {
                id: viewsText
                anchors.centerIn: parent
                text: "👁 " + formatViews(root.views)
                font.pixelSize: Theme.fontSizeXs
                color: Theme.textMuted
            }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: root.toggled()
    }
    
    function formatViews(views) {
        if (views >= 1000000) {
            return (views / 1000000).toFixed(1) + "M"
        } else if (views >= 1000) {
            return (views / 1000).toFixed(1) + "K"
        }
        return views.toString()
    }
}
