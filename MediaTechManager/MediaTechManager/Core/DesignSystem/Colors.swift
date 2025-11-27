//
//  Colors.swift
//  MediaTechManager
//
//  Design System - Farbdefinitionen
//

import SwiftUI

extension Color {

    // MARK: - Brand Colors

    /// Primäre Markenfarbe (Apple Blue)
    static let brandPrimary = Color("BrandPrimary")

    /// Sekundäre Markenfarbe (Purple)
    static let brandSecondary = Color("BrandSecondary")

    /// Akzentfarbe (Orange)
    static let brandAccent = Color("BrandAccent")

    // MARK: - Semantic Colors

    /// Erfolg / Verfügbar
    static let success = Color("Success")

    /// Warnung / Ausgeliehen
    static let warning = Color("Warning")

    /// Fehler / Überfällig
    static let error = Color("Error")

    /// Information
    static let info = Color("Info")

    // MARK: - Status Colors (Ausleihen)

    /// Reserviert
    static let statusReserved = Color("StatusReserved")

    /// Aktiv / Ausgeliehen
    static let statusActive = Color("StatusActive")

    /// Überfällig
    static let statusOverdue = Color("StatusOverdue")

    /// Zurückgegeben
    static let statusReturned = Color("StatusReturned")

    // MARK: - Background Colors

    /// Primärer Hintergrund
    static let backgroundPrimary = Color("BackgroundPrimary")

    /// Sekundärer Hintergrund
    static let backgroundSecondary = Color("BackgroundSecondary")

    /// Tertiärer Hintergrund (Karten)
    static let backgroundTertiary = Color("BackgroundTertiary")

    // MARK: - Text Colors

    /// Primärer Text
    static let textPrimary = Color("TextPrimary")

    /// Sekundärer Text
    static let textSecondary = Color("TextSecondary")

    /// Tertiärer Text
    static let textTertiary = Color("TextTertiary")

    // MARK: - Fallback Colors (wenn Assets fehlen)

    /// Fallback für Brand Primary
    static var brandPrimaryFallback: Color {
        Color(light: Color(hex: "007AFF"), dark: Color(hex: "0A84FF"))
    }

    /// Fallback für Brand Secondary
    static var brandSecondaryFallback: Color {
        Color(light: Color(hex: "5856D6"), dark: Color(hex: "5E5CE6"))
    }

    /// Fallback für Success
    static var successFallback: Color {
        Color(light: Color(hex: "34C759"), dark: Color(hex: "30D158"))
    }

    /// Fallback für Warning
    static var warningFallback: Color {
        Color(light: Color(hex: "FF9500"), dark: Color(hex: "FF9F0A"))
    }

    /// Fallback für Error
    static var errorFallback: Color {
        Color(light: Color(hex: "FF3B30"), dark: Color(hex: "FF453A"))
    }
}

// MARK: - Color Extension for Hex

extension Color {

    /// Erstellt eine Farbe aus einem Hex-String
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Erstellt eine Farbe mit unterschiedlichen Werten für Light und Dark Mode
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Safe Color Access

extension Color {

    /// Sichere Farbzugriff mit Fallback
    static func safe(_ name: String, fallback: Color) -> Color {
        if UIColor(named: name) != nil {
            return Color(name)
        }
        return fallback
    }
}
