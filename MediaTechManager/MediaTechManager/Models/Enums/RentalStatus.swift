//
//  RentalStatus.swift
//  MediaTechManager
//
//  Enum - Ausleihe-Status
//

import SwiftUI

/// Status einer Ausleihe
enum RentalStatus: String, CaseIterable, Codable {

    /// Reserviert, noch nicht abgeholt
    case reserved = "Reserviert"

    /// Aktiv, Gerät ist beim Kunden
    case active = "Ausgeliehen"

    /// Überfällig, Rückgabe überschritten
    case overdue = "Überfällig"

    /// Zurückgegeben
    case returned = "Zurückgegeben"

    /// Storniert
    case cancelled = "Storniert"

    // MARK: - Properties

    /// Lokalisierter Name
    var displayName: String {
        rawValue
    }

    /// SF Symbol Icon
    var icon: String {
        switch self {
        case .reserved:
            return "calendar.badge.clock"
        case .active:
            return "arrow.right.circle.fill"
        case .overdue:
            return "exclamationmark.triangle.fill"
        case .returned:
            return "checkmark.circle.fill"
        case .cancelled:
            return "xmark.circle.fill"
        }
    }

    /// Farbe
    var color: Color {
        switch self {
        case .reserved:
            return .statusReserved
        case .active:
            return .statusActive
        case .overdue:
            return .statusOverdue
        case .returned:
            return .statusReturned
        case .cancelled:
            return .gray
        }
    }

    /// Fallback Farbe (falls Asset fehlt)
    var fallbackColor: Color {
        switch self {
        case .reserved:
            return Color(hex: "007AFF")
        case .active:
            return Color(hex: "34C759")
        case .overdue:
            return Color(hex: "FF3B30")
        case .returned:
            return Color(hex: "8E8E93")
        case .cancelled:
            return Color(hex: "636366")
        }
    }

    /// Kann der Status bearbeitet werden?
    var isEditable: Bool {
        switch self {
        case .reserved, .active, .overdue:
            return true
        case .returned, .cancelled:
            return false
        }
    }

    /// Ist die Ausleihe aktiv?
    var isActive: Bool {
        switch self {
        case .active, .overdue:
            return true
        default:
            return false
        }
    }

    /// Ist die Ausleihe abgeschlossen?
    var isCompleted: Bool {
        switch self {
        case .returned, .cancelled:
            return true
        default:
            return false
        }
    }

    /// Mögliche Folgestatus
    var possibleNextStatuses: [RentalStatus] {
        switch self {
        case .reserved:
            return [.active, .cancelled]
        case .active:
            return [.returned, .overdue]
        case .overdue:
            return [.returned]
        case .returned:
            return []
        case .cancelled:
            return []
        }
    }
}
