import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import ".."

Popup {
    id: root
    
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    width: 500
    height: contentColumn.implicitHeight + Theme.spacingLg * 2
    
    property string selectedFormat: backend.outputFormat
    property bool keepImages: backend.keepImages
    property string downloadDir: backend.downloadDir
    property int concurrentChapters: backend.maxConcurrentChapters
    property int concurrentImages: backend.maxConcurrentImages
    property bool enableLogs: backend.enableLogs
    
    background: Rectangle {
        color: Theme.cardBg
        radius: Theme.radiusLg
        border.width: 1
        border.color: Theme.elevated
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
                text: "⚙️"
                font.pixelSize: 24
            }
            
            Text {
                text: "Settings"
                font.pixelSize: Theme.fontSizeLg
                font.bold: true
                color: Theme.textPrimary
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
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.elevated
        }
        
        // Download directory
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingXs
            
            Text {
                text: "📂 Download Directory"
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Medium
                color: Theme.textSecondary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSm
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: Theme.radiusSm
                    color: Theme.secondaryBg
                    border.width: 1
                    border.color: Theme.elevated
                    
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: Theme.spacingSm
                        text: root.downloadDir
                        font.pixelSize: Theme.fontSizeSm
                        font.family: "Consolas, monospace"
                        color: Theme.textSecondary
                        elide: Text.ElideMiddle
                    }
                }
                
                SecondaryButton {
                    text: "Browse"
                    onClicked: folderDialog.open()
                }
            }
        }
        
        // Output format
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingXs
            
            Text {
                text: "📄 Output Format"
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Medium
                color: Theme.textSecondary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSm
                
                FormatOption {
                    text: "Images"
                    icon: "🖼️"
                    selected: root.selectedFormat === "images"
                    onClicked: root.selectedFormat = "images"
                }
                
                FormatOption {
                    text: "PDF"
                    icon: "📄"
                    selected: root.selectedFormat === "pdf"
                    onClicked: root.selectedFormat = "pdf"
                }
                
                FormatOption {
                    text: "CBZ"
                    icon: "📦"
                    selected: root.selectedFormat === "cbz"
                    onClicked: root.selectedFormat = "cbz"
                }
            }
        }
        
        // Keep images option
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            visible: root.selectedFormat !== "images"
            
            CheckboxItem {
                checked: root.keepImages
                onToggled: root.keepImages = !root.keepImages
            }
            
            Text {
                text: "Keep original images after conversion"
                font.pixelSize: Theme.fontSizeSm
                color: Theme.textSecondary
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.keepImages = !root.keepImages
                }
            }
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.elevated
        }
        
        // Concurrency settings
        Text {
            text: "⚡ Performance"
            font.pixelSize: Theme.fontSizeSm
            font.weight: Font.Medium
            color: Theme.textSecondary
        }
        
        // Max concurrent chapters
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingMd
            
            Text {
                text: "Concurrent Chapters"
                font.pixelSize: Theme.fontSizeSm
                color: Theme.textSecondary
                Layout.preferredWidth: 150
            }
            
            SpinBoxCustom {
                value: root.concurrentChapters
                minValue: 1
                maxValue: 10
                onValueChanged: root.concurrentChapters = value
            }
            
            Text {
                text: "(1-10)"
                font.pixelSize: Theme.fontSizeXs
                color: Theme.textMuted
            }
        }
        
        // Max concurrent images
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingMd
            
            Text {
                text: "Concurrent Images"
                font.pixelSize: Theme.fontSizeSm
                color: Theme.textSecondary
                Layout.preferredWidth: 150
            }
            
            SpinBoxCustom {
                value: root.concurrentImages
                minValue: 1
                maxValue: 20
                onValueChanged: root.concurrentImages = value
            }
            
            Text {
                text: "(1-20)"
                font.pixelSize: Theme.fontSizeXs
                color: Theme.textMuted
            }
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.elevated
        }
        
        // Enable logs
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            
            CheckboxItem {
                checked: root.enableLogs
                onToggled: root.enableLogs = !root.enableLogs
            }
            
            ColumnLayout {
                spacing: 2
                
                Text {
                    text: "Enable Debug Logs"
                    font.pixelSize: Theme.fontSizeSm
                    color: Theme.textSecondary
                }
                
                Text {
                    text: "Show detailed output in console"
                    font.pixelSize: Theme.fontSizeXs
                    color: Theme.textMuted
                }
            }
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.elevated
        }
        
        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingSm
            
            Item { Layout.fillWidth: true }
            
            SecondaryButton {
                text: "Cancel"
                onClicked: root.close()
            }
            
            PrimaryButton {
                text: "Save"
                icon: "💾"
                onClicked: {
                    backend.setOutputFormat(root.selectedFormat)
                    backend.setKeepImages(root.keepImages)
                    backend.setMaxConcurrentChapters(root.concurrentChapters)
                    backend.setMaxConcurrentImages(root.concurrentImages)
                    backend.setEnableLogs(root.enableLogs)
                    if (root.downloadDir !== backend.downloadDir) {
                        backend.setDownloadDir(root.downloadDir)
                    }
                    root.close()
                }
            }
        }
    }
    
    // Checkbox component
    component CheckboxItem: Rectangle {
        property bool checked: false
        signal toggled()
        
        width: 24
        height: 24
        radius: Theme.radiusSm
        color: checked ? Theme.accent : "transparent"
        border.width: 2
        border.color: checked ? Theme.accent : Theme.textMuted
        
        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }
        
        Text {
            anchors.centerIn: parent
            text: "✓"
            font.pixelSize: 14
            font.bold: true
            color: Theme.textPrimary
            opacity: parent.checked ? 1 : 0
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.toggled()
        }
    }
    
    // Format option component
    component FormatOption: Rectangle {
        property string text: ""
        property string icon: ""
        property bool selected: false
        
        signal clicked()
        
        width: (contentColumn.width - Theme.spacingLg * 2 - Theme.spacingSm * 2) / 3
        height: 60
        radius: Theme.radiusMd
        color: selected ? Theme.elevated : Theme.secondaryBg
        border.width: selected ? 2 : 1
        border.color: selected ? Theme.accent : Theme.elevated
        
        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }
        
        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }
        
        Column {
            anchors.centerIn: parent
            spacing: Theme.spacingXs
            
            Text {
                text: parent.parent.icon
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: parent.parent.text
                font.pixelSize: Theme.fontSizeSm
                font.weight: parent.parent.selected ? Font.Bold : Font.Normal
                color: parent.parent.selected ? Theme.textPrimary : Theme.textSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }
    
    // Custom spin box component
    component SpinBoxCustom: Row {
        property int value: 1
        property int minValue: 1
        property int maxValue: 10
        
        spacing: Theme.spacingXs
        
        Rectangle {
            width: 32
            height: 32
            radius: Theme.radiusSm
            color: minusArea.containsMouse ? Theme.elevated : Theme.secondaryBg
            
            Text {
                anchors.centerIn: parent
                text: "−"
                font.pixelSize: Theme.fontSizeMd
                font.bold: true
                color: parent.parent.value > parent.parent.minValue ? Theme.textPrimary : Theme.textMuted
            }
            
            MouseArea {
                id: minusArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (parent.parent.value > parent.parent.minValue) {
                        parent.parent.value--
                    }
                }
            }
        }
        
        Rectangle {
            width: 50
            height: 32
            radius: Theme.radiusSm
            color: Theme.secondaryBg
            
            Text {
                anchors.centerIn: parent
                text: parent.parent.value
                font.pixelSize: Theme.fontSizeMd
                font.bold: true
                color: Theme.textPrimary
            }
        }
        
        Rectangle {
            width: 32
            height: 32
            radius: Theme.radiusSm
            color: plusArea.containsMouse ? Theme.elevated : Theme.secondaryBg
            
            Text {
                anchors.centerIn: parent
                text: "+"
                font.pixelSize: Theme.fontSizeMd
                font.bold: true
                color: parent.parent.value < parent.parent.maxValue ? Theme.textPrimary : Theme.textMuted
            }
            
            MouseArea {
                id: plusArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (parent.parent.value < parent.parent.maxValue) {
                        parent.parent.value++
                    }
                }
            }
        }
    }
    
    FolderDialog {
        id: folderDialog
        title: "Select Download Directory"
        currentFolder: "file:///" + root.downloadDir
        
        onAccepted: {
            root.downloadDir = selectedFolder.toString().replace("file:///", "")
        }
    }
}
