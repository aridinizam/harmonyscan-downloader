pragma Singleton
import QtQuick

QtObject {
    // ============ COLORS ============
    // Background Colors
    readonly property color primaryBg: "#0F0F0F"
    readonly property color secondaryBg: "#1A1A2E"
    readonly property color cardBg: "#16213E"
    readonly property color elevated: "#1F4068"
    
    // Accent Colors
    readonly property color accent: "#FF6B9D"
    readonly property color accentSecondary: "#C084FC"
    readonly property color accentTertiary: "#22D3EE"
    
    // Status Colors
    readonly property color success: "#4ADE80"
    readonly property color warning: "#FBBF24"
    readonly property color error: "#F87171"
    readonly property color info: "#60A5FA"
    
    // Text Colors
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#94A3B8"
    readonly property color textMuted: "#64748B"
    
    // ============ TYPOGRAPHY ============
    readonly property string fontFamily: "Segoe UI, Inter, sans-serif"
    readonly property int fontSizeXs: 10
    readonly property int fontSizeSm: 12
    readonly property int fontSizeMd: 14
    readonly property int fontSizeLg: 18
    readonly property int fontSizeXl: 24
    readonly property int fontSize2Xl: 32
    
    // ============ SPACING ============
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 16
    readonly property int spacingLg: 24
    readonly property int spacingXl: 32
    readonly property int spacing2Xl: 48
    
    // ============ BORDER RADIUS ============
    readonly property int radiusSm: 8
    readonly property int radiusMd: 12
    readonly property int radiusLg: 16
    readonly property int radiusFull: 9999
    
    // ============ SHADOWS ============
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.4)
    
    // ============ ANIMATION DURATIONS ============
    readonly property int animFast: 150
    readonly property int animNormal: 300
    readonly property int animSlow: 500
    
    // ============ GRADIENTS ============
    function accentGradient() {
        return [accent, accentSecondary]
    }
    
    function bgGradient() {
        return [primaryBg, secondaryBg]
    }
}
