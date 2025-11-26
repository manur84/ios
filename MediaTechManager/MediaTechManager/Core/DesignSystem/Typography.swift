//
//  Typography.swift
//  MediaTechManager
//
//  Design System - Schriftdefinitionen
//

import SwiftUI

extension Font {

    // MARK: - Display (Headlines)

    /// Display Large - 34pt Bold Rounded
    static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)

    /// Display Medium - 28pt Bold Rounded
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)

    /// Display Small - 22pt Bold Rounded
    static let displaySmall = Font.system(size: 22, weight: .bold, design: .rounded)

    // MARK: - Titles

    /// Title Large - 20pt Semibold
    static let titleLarge = Font.system(size: 20, weight: .semibold)

    /// Title Medium - 17pt Semibold
    static let titleMedium = Font.system(size: 17, weight: .semibold)

    /// Title Small - 15pt Semibold
    static let titleSmall = Font.system(size: 15, weight: .semibold)

    // MARK: - Body

    /// Body Large - 17pt Regular
    static let bodyLarge = Font.system(size: 17, weight: .regular)

    /// Body Medium - 15pt Regular
    static let bodyMedium = Font.system(size: 15, weight: .regular)

    /// Body Small - 13pt Regular
    static let bodySmall = Font.system(size: 13, weight: .regular)

    // MARK: - Labels

    /// Label Large - 15pt Medium
    static let labelLarge = Font.system(size: 15, weight: .medium)

    /// Label Medium - 13pt Medium
    static let labelMedium = Font.system(size: 13, weight: .medium)

    /// Label Small - 11pt Medium
    static let labelSmall = Font.system(size: 11, weight: .medium)

    // MARK: - Monospace (für IDs, Seriennummern)

    /// Mono Large - 17pt Medium Monospaced
    static let monoLarge = Font.system(size: 17, weight: .medium, design: .monospaced)

    /// Mono Medium - 15pt Medium Monospaced
    static let monoMedium = Font.system(size: 15, weight: .medium, design: .monospaced)

    /// Mono Small - 13pt Medium Monospaced
    static let monoSmall = Font.system(size: 13, weight: .medium, design: .monospaced)

    // MARK: - Caption

    /// Caption - 12pt Regular
    static let caption = Font.system(size: 12, weight: .regular)

    /// Caption Bold - 12pt Semibold
    static let captionBold = Font.system(size: 12, weight: .semibold)
}

// MARK: - Text Styles für Dynamic Type

extension Font {

    /// Dynamisch skalierender Display-Stil
    static func dynamicDisplay(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        Font.system(size: size, weight: weight, design: .rounded)
    }

    /// Dynamisch skalierender Title-Stil
    static func dynamicTitle(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        Font.system(size: size, weight: weight)
    }

    /// Dynamisch skalierender Body-Stil
    static func dynamicBody(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.system(size: size, weight: weight)
    }
}
