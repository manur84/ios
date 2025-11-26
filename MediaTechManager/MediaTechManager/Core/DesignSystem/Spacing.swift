//
//  Spacing.swift
//  MediaTechManager
//
//  Design System - Abstände und Spacing
//

import SwiftUI

/// Konsistente Spacing-Werte für die gesamte App
enum Spacing {

    // MARK: - Base Spacing Scale

    /// Extra Extra Extra Small - 2pt
    static let xxxs: CGFloat = 2

    /// Extra Extra Small - 4pt
    static let xxs: CGFloat = 4

    /// Extra Small - 8pt
    static let xs: CGFloat = 8

    /// Small - 12pt
    static let sm: CGFloat = 12

    /// Medium - 16pt
    static let md: CGFloat = 16

    /// Large - 20pt
    static let lg: CGFloat = 20

    /// Extra Large - 24pt
    static let xl: CGFloat = 24

    /// Extra Extra Large - 32pt
    static let xxl: CGFloat = 32

    /// Extra Extra Extra Large - 40pt
    static let xxxl: CGFloat = 40

    // MARK: - Semantic Spacing

    /// Padding für Karten
    static let cardPadding: CGFloat = 16

    /// Abstand zwischen Sektionen
    static let sectionSpacing: CGFloat = 24

    /// Abstand zwischen Listen-Elementen
    static let listItemSpacing: CGFloat = 12

    /// Abstand zwischen Icon und Text
    static let iconTextSpacing: CGFloat = 8

    /// Inset für Gruppen-Listen
    static let listInset: CGFloat = 16

    /// Abstand für Form-Elemente
    static let formSpacing: CGFloat = 20

    /// Toolbar-Padding
    static let toolbarPadding: CGFloat = 16

    // MARK: - Screen Edge Padding

    /// Horizontales Padding zum Bildschirmrand
    static let screenHorizontal: CGFloat = 16

    /// Vertikales Padding zum Bildschirmrand
    static let screenVertical: CGFloat = 16
}

// MARK: - EdgeInsets Extension

extension EdgeInsets {

    /// Standard Karten-Insets
    static let card = EdgeInsets(
        top: Spacing.cardPadding,
        leading: Spacing.cardPadding,
        bottom: Spacing.cardPadding,
        trailing: Spacing.cardPadding
    )

    /// Standard Screen-Insets
    static let screen = EdgeInsets(
        top: Spacing.screenVertical,
        leading: Spacing.screenHorizontal,
        bottom: Spacing.screenVertical,
        trailing: Spacing.screenHorizontal
    )

    /// Horizontale Insets
    static func horizontal(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: value)
    }

    /// Vertikale Insets
    static func vertical(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: value, trailing: 0)
    }

    /// Gleichmäßige Insets
    static func all(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
}
