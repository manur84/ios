//
//  CustomerType.swift
//  MediaTechManager
//
//  Kundentypen
//

import Foundation

enum CustomerType: String, Codable, CaseIterable {
    case `private` = "private"
    case business = "business"
    case educational = "educational"
    case nonprofit = "nonprofit"

    var displayName: String {
        switch self {
        case .private:
            return "Privat"
        case .business:
            return "Geschäftlich"
        case .educational:
            return "Bildung"
        case .nonprofit:
            return "Gemeinnützig"
        }
    }

    var colorHex: String {
        switch self {
        case .private:
            return "007AFF" // Blue
        case .business:
            return "5856D6" // Purple
        case .educational:
            return "34C759" // Green
        case .nonprofit:
            return "FF9500" // Orange
        }
    }

    var icon: String {
        switch self {
        case .private:
            return "person.fill"
        case .business:
            return "building.2.fill"
        case .educational:
            return "graduationcap.fill"
        case .nonprofit:
            return "heart.fill"
        }
    }
}
