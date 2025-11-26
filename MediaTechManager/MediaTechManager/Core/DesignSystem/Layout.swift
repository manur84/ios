//
//  Layout.swift
//  MediaTechManager
//
//  Design System - Layout-Konstanten
//

import SwiftUI

/// Layout-Konstanten für konsistentes Design
enum Layout {

    // MARK: - Corner Radius

    /// Kleiner Eckenradius - 8pt
    static let cornerRadiusSmall: CGFloat = 8

    /// Mittlerer Eckenradius - 12pt
    static let cornerRadiusMedium: CGFloat = 12

    /// Großer Eckenradius - 16pt
    static let cornerRadiusLarge: CGFloat = 16

    /// Extra großer Eckenradius - 20pt
    static let cornerRadiusXL: CGFloat = 20

    /// Vollständig rund (für Kreise/Pills)
    static let cornerRadiusFull: CGFloat = 9999

    // MARK: - Border

    /// Standard Rahmenbreite
    static let borderWidth: CGFloat = 1

    /// Dicke Rahmenbreite
    static let borderWidthThick: CGFloat = 2

    // MARK: - Shadow

    /// Standard Schattenradius
    static let shadowRadius: CGFloat = 8

    /// Kleine Schatten
    static let shadowRadiusSmall: CGFloat = 4

    /// Große Schatten
    static let shadowRadiusLarge: CGFloat = 16

    /// Standard Schattenopazität
    static let shadowOpacity: CGFloat = 0.1

    // MARK: - Touch Targets

    /// Minimale Touch-Target Größe (Apple HIG)
    static let minTouchTarget: CGFloat = 44

    /// Minimale Button-Höhe
    static let minButtonHeight: CGFloat = 44

    /// Standard Button-Höhe
    static let buttonHeight: CGFloat = 50

    // MARK: - Content Width

    /// Maximale Inhaltsbreite (für iPad)
    static let maxContentWidth: CGFloat = 700

    /// Maximale Formularbreite
    static let maxFormWidth: CGFloat = 500

    // MARK: - Image Sizes

    /// Thumbnail-Größe
    static let thumbnailSize: CGFloat = 60

    /// Icon-Größe klein
    static let iconSizeSmall: CGFloat = 20

    /// Icon-Größe mittel
    static let iconSizeMedium: CGFloat = 24

    /// Icon-Größe groß
    static let iconSizeLarge: CGFloat = 32

    /// Avatar-Größe
    static let avatarSize: CGFloat = 40

    // MARK: - List

    /// Listen-Zeilen Höhe
    static let listRowHeight: CGFloat = 60

    /// Listen-Zeilen Mindesthöhe
    static let listRowMinHeight: CGFloat = 44
}

// MARK: - RoundedRectangle Convenience

extension RoundedRectangle {

    /// Kleine abgerundete Ecken
    static var small: RoundedRectangle {
        RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall)
    }

    /// Mittlere abgerundete Ecken
    static var medium: RoundedRectangle {
        RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium)
    }

    /// Große abgerundete Ecken
    static var large: RoundedRectangle {
        RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge)
    }

    /// Extra große abgerundete Ecken
    static var xl: RoundedRectangle {
        RoundedRectangle(cornerRadius: Layout.cornerRadiusXL)
    }
}

// MARK: - Shadow Style

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    /// Standard Schatten
    static let standard = ShadowStyle(
        color: .black.opacity(Layout.shadowOpacity),
        radius: Layout.shadowRadius,
        x: 0,
        y: 4
    )

    /// Kleiner Schatten
    static let small = ShadowStyle(
        color: .black.opacity(0.05),
        radius: Layout.shadowRadiusSmall,
        x: 0,
        y: 2
    )

    /// Großer Schatten
    static let large = ShadowStyle(
        color: .black.opacity(0.15),
        radius: Layout.shadowRadiusLarge,
        x: 0,
        y: 8
    )
}

// MARK: - View Extension für Shadow

extension View {

    /// Wendet einen ShadowStyle an
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}
