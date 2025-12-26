import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
import "../components"

Item {
    id: root
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacingLg
        
        // Animated spinner
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80
            height: 80
            radius: Theme.radiusFull
            color: "transparent"
            border.width: 4
            border.color: Theme.accent
            
            Rectangle {
                width: parent.width
                height: parent.height
                radius: parent.radius
                color: "transparent"
                border.width: 4
                border.color: Theme.accentSecondary
                
                // Spinning arc effect
                Rectangle {
                    width: 20
                    height: 4
                    radius: 2
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: -2
                    color: Theme.accentSecondary
                }
                
                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: true
                }
            }
            
            Text {
                anchors.centerIn: parent
                text: "📖"
                font.pixelSize: 28
                
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    running: true
                    NumberAnimation { to: 1.1; duration: 500; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                }
            }
        }
        
        // Loading text
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Fetching manga information..."
            font.pixelSize: Theme.fontSizeLg
            color: Theme.textPrimary
        }
        
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "This may take a moment"
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textMuted
        }
        
        // Skeleton preview
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Theme.spacingLg
            width: 500
            height: 180
            radius: Theme.radiusMd
            color: Theme.cardBg
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingMd
                spacing: Theme.spacingMd
                
                // Cover skeleton
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.fillHeight: true
                    radius: Theme.radiusSm
                    color: Theme.secondaryBg
                    
                    SkeletonShimmer { anchors.fill: parent }
                }
                
                // Info skeleton
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.spacingSm
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width * 0.8
                        height: 24
                        radius: Theme.radiusSm
                        color: Theme.secondaryBg
                        
                        SkeletonShimmer { anchors.fill: parent }
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: parent.width * 0.5
                        height: 16
                        radius: Theme.radiusSm
                        color: Theme.secondaryBg
                        
                        SkeletonShimmer { anchors.fill: parent }
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: parent.width * 0.6
                        height: 16
                        radius: Theme.radiusSm
                        color: Theme.secondaryBg
                        
                        SkeletonShimmer { anchors.fill: parent }
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    Row {
                        spacing: Theme.spacingSm
                        
                        Repeater {
                            model: 3
                            
                            Rectangle {
                                width: 50
                                height: 20
                                radius: Theme.radiusSm
                                color: Theme.secondaryBg
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Skeleton shimmer component
    component SkeletonShimmer: Rectangle {
        id: shimmerContainer
        clip: true
        color: "transparent"
        
        Rectangle {
            id: shimmer
            width: parent.width * 0.5
            height: parent.height
            
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.1) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            SequentialAnimation on x {
                loops: Animation.Infinite
                running: true
                
                PropertyAnimation {
                    from: -shimmer.width
                    to: shimmerContainer.width
                    duration: 1500
                }
                
                PauseAnimation { duration: 500 }
            }
        }
    }
}
