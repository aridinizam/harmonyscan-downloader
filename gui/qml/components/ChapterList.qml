import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    
    signal selectionChanged()
    
    radius: Theme.radiusMd
    color: Theme.cardBg
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingMd
        spacing: Theme.spacingSm
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            
            Text {
                text: "📋"
                font.pixelSize: Theme.fontSizeMd
            }
            
            Text {
                text: "Chapters"
                font.pixelSize: Theme.fontSizeMd
                font.bold: true
                color: Theme.textPrimary
            }
            
            Text {
                text: "(" + chapterModel.rowCount() + ")"
                font.pixelSize: Theme.fontSizeSm
                color: Theme.textSecondary
            }
            
            Item { Layout.fillWidth: true }
            
            // Selection count
            Text {
                text: chapterModel.selectedCount() + " selected"
                font.pixelSize: Theme.fontSizeSm
                color: Theme.accent
                visible: chapterModel.selectedCount() > 0
            }
        }
        
        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            
            SecondaryButton {
                text: "Select All"
                icon: "☑"
                onClicked: {
                    chapterModel.selectAll()
                    root.selectionChanged()
                }
            }
            
            SecondaryButton {
                text: "Clear"
                icon: "☐"
                onClicked: {
                    chapterModel.clearSelection()
                    root.selectionChanged()
                }
            }
            
            Item { Layout.fillWidth: true }
        }
        
        // Chapter list
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Theme.spacingXs
            
            model: chapterModel
            
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
            
            delegate: ChapterItem {
                width: listView.width - Theme.spacingSm
                chapterTitle: model.title
                chapterNumber: model.number
                views: model.views
                selected: model.selected
                
                onToggled: {
                    chapterModel.toggleSelection(index)
                    root.selectionChanged()
                }
            }
            
            // Empty state
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                visible: listView.count === 0
                
                Column {
                    anchors.centerIn: parent
                    spacing: Theme.spacingSm
                    
                    Text {
                        text: "📭"
                        font.pixelSize: 48
                        opacity: 0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        text: "No chapters available"
                        font.pixelSize: Theme.fontSizeMd
                        color: Theme.textMuted
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}
