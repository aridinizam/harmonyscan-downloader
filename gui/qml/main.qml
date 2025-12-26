import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "."
import "components"
import "screens"

ApplicationWindow {
    id: root
    
    width: 1100
    height: 750
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: "HarmonyScan Downloader"
    color: Theme.primaryBg
    
    // Frameless window
    flags: Qt.Window | Qt.FramelessWindowHint
    
    // Current screen state
    property string currentScreen: "welcome"  // welcome, loading, download, complete
    property int downloadedCount: 0
    property int totalCount: 0
    
    // Connect to backend signals
    Connections {
        target: backend
        
        function onMangaInfoChanged() {
            if (backend.hasMangaInfo) {
                root.currentScreen = "download"
            }
        }
        
        function onLoadingChanged(loading) {
            if (loading) {
                root.currentScreen = "loading"
            }
        }
        
        function onDownloadComplete(success, message, downloaded, total) {
            root.downloadedCount = downloaded
            root.totalCount = total
            root.currentScreen = "complete"
        }
        
        function onErrorOccurred(error) {
            errorDialog.errorMessage = error
            errorDialog.open()
        }
    }
    
    // Main layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Custom title bar
        TitleBar {
            id: titleBar
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            window: root
        }
        
        // Content area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Welcome Screen
            WelcomeScreen {
                anchors.fill: parent
                visible: root.currentScreen === "welcome"
                opacity: visible ? 1 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animNormal }
                }
                
                onFetchRequested: function(url) {
                    backend.fetchManga(url)
                }
            }
            
            // Loading Screen
            LoadingScreen {
                anchors.fill: parent
                visible: root.currentScreen === "loading"
                opacity: visible ? 1 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animNormal }
                }
            }
            
            // Download Screen
            DownloadScreen {
                anchors.fill: parent
                visible: root.currentScreen === "download"
                opacity: visible ? 1 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animNormal }
                }
                
                onBackRequested: {
                    chapterModel.clear()
                    backend.clearMangaInfo()
                    root.currentScreen = "welcome"
                }
            }
            
            // Complete Screen
            CompleteScreen {
                anchors.fill: parent
                visible: root.currentScreen === "complete"
                opacity: visible ? 1 : 0
                downloadedCount: root.downloadedCount
                totalCount: root.totalCount
                
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animNormal }
                }
                
                onNewDownloadRequested: {
                    chapterModel.clear()
                    backend.clearMangaInfo()
                    root.currentScreen = "welcome"
                }
            }
        }
    }
    
    // Error Dialog
    ErrorDialog {
        id: errorDialog
        anchors.centerIn: parent
    }
    
    // Settings Dialog
    SettingsDialog {
        id: settingsDialog
        anchors.centerIn: parent
    }
    
    // Window resize handles
    MouseArea {
        id: resizeBottomRight
        width: 16
        height: 16
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor
        
        property point clickPos: Qt.point(0, 0)
        
        onPressed: function(mouse) {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        
        onPositionChanged: function(mouse) {
            if (pressed) {
                var dx = mouse.x - clickPos.x
                var dy = mouse.y - clickPos.y
                root.width = Math.max(root.minimumWidth, root.width + dx)
                root.height = Math.max(root.minimumHeight, root.height + dy)
            }
        }
    }
}
