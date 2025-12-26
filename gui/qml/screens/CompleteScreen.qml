import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
import "../components"

Item {
    id: root
    
    property int downloadedCount: 0
    property int totalCount: 0
    
    signal newDownloadRequested()
    
    property bool success: downloadedCount > 0
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacingLg
        
        // Success/Failure icon
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 100
            height: 100
            radius: Theme.radiusFull
            color: root.success ? Theme.success : Theme.error
            opacity: 0.2
            
            Text {
                anchors.centerIn: parent
                text: root.success ? "✓" : "✗"
                font.pixelSize: 48
                font.bold: true
                color: root.success ? Theme.success : Theme.error
            }
            
            // Ripple animation on appear
            Rectangle {
                id: ripple
                anchors.centerIn: parent
                width: 0
                height: 0
                radius: width / 2
                color: root.success ? Theme.success : Theme.error
                opacity: 0.3
                
                SequentialAnimation {
                    running: true
                    
                    ParallelAnimation {
                        NumberAnimation {
                            target: ripple
                            property: "width"
                            to: 150
                            duration: 600
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: ripple
                            property: "height"
                            to: 150
                            duration: 600
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: ripple
                            property: "opacity"
                            to: 0
                            duration: 600
                        }
                    }
                }
            }
        }
        
        // Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.success ? "Download Complete!" : "Download Failed"
            font.pixelSize: Theme.fontSize2Xl
            font.bold: true
            color: Theme.textPrimary
        }
        
        // Summary
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.downloadedCount + " of " + root.totalCount + " chapters downloaded successfully"
            font.pixelSize: Theme.fontSizeMd
            color: Theme.textSecondary
        }
        
        // Stats card
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Theme.spacingMd
            width: 300
            height: statsColumn.implicitHeight + Theme.spacingMd * 2
            radius: Theme.radiusMd
            color: Theme.cardBg
            
            ColumnLayout {
                id: statsColumn
                anchors.fill: parent
                anchors.margins: Theme.spacingMd
                spacing: Theme.spacingSm
                
                StatRow {
                    icon: "✓"
                    label: "Successful"
                    value: root.downloadedCount.toString()
                    valueColor: Theme.success
                }
                
                StatRow {
                    icon: "✗"
                    label: "Failed"
                    value: (root.totalCount - root.downloadedCount).toString()
                    valueColor: Theme.error
                    visible: root.totalCount > root.downloadedCount
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.elevated
                }
                
                StatRow {
                    icon: "📂"
                    label: "Saved to"
                    value: backend ? backend.downloadDir : "./downloads"
                    valueColor: Theme.textMuted
                    valueSmall: true
                }
            }
        }
        
        // Action buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Theme.spacingLg
            spacing: Theme.spacingMd
            
            SecondaryButton {
                text: "Open Folder"
                icon: "📂"
                onClicked: backend.openDownloadFolder()
            }
            
            PrimaryButton {
                text: "Download Another"
                icon: "📖"
                onClicked: root.newDownloadRequested()
            }
        }
        
        // Confetti effect for success
        Item {
            Layout.fillWidth: true
            height: 1
            visible: root.success
            
            Repeater {
                model: 30
                
                Rectangle {
                    id: confetti
                    x: Math.random() * root.width - root.width / 2
                    y: -100
                    width: 8 + Math.random() * 8
                    height: width
                    radius: Math.random() > 0.5 ? width / 2 : 0
                    color: [Theme.accent, Theme.accentSecondary, Theme.success, Theme.warning, Theme.info][Math.floor(Math.random() * 5)]
                    rotation: Math.random() * 360
                    
                    ParallelAnimation {
                        running: root.visible && root.success
                        
                        NumberAnimation {
                            target: confetti
                            property: "y"
                            to: root.height + 100
                            duration: 2000 + Math.random() * 1000
                            easing.type: Easing.InQuad
                        }
                        
                        NumberAnimation {
                            target: confetti
                            property: "rotation"
                            to: confetti.rotation + 360 * (Math.random() > 0.5 ? 1 : -1)
                            duration: 2000 + Math.random() * 1000
                        }
                        
                        NumberAnimation {
                            target: confetti
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 2000 + Math.random() * 1000
                        }
                    }
                }
            }
        }
    }
    
    // Stat row component
    component StatRow: RowLayout {
        property string icon: ""
        property string label: ""
        property string value: ""
        property color valueColor: Theme.textPrimary
        property bool valueSmall: false
        
        Layout.fillWidth: true
        spacing: Theme.spacingSm
        
        Text {
            text: icon
            font.pixelSize: Theme.fontSizeSm
        }
        
        Text {
            text: label
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textSecondary
        }
        
        Item { Layout.fillWidth: true }
        
        Text {
            text: value
            font.pixelSize: valueSmall ? Theme.fontSizeXs : Theme.fontSizeSm
            font.bold: !valueSmall
            color: valueColor
            elide: Text.ElideMiddle
            Layout.maximumWidth: 150
        }
    }
}
