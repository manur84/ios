//
//  Location.swift
//  MediaTechManager
//
//  SwiftData Model - Standorte
//

import Foundation
import SwiftData

@Model
final class Location {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Name des Standorts
    var name: String

    /// Beschreibung / Details
    var descriptionText: String

    /// Adresse
    var address: String

    /// SF Symbol Name für Icon
    var iconName: String

    /// Farbe als Hex-String
    var colorHex: String

    /// Sortierreihenfolge
    var sortOrder: Int

    /// Ist aktiv
    var isActive: Bool

    /// Erstellungsdatum
    var createdAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        name: String,
        descriptionText: String = "",
        address: String = "",
        iconName: String = "mappin.circle.fill",
        colorHex: String = "FF3B30",
        sortOrder: Int = 0,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.address = address
        self.iconName = iconName
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension Location: Identifiable {}

// MARK: - Predefined Locations

extension Location {

    /// Vordefinierte Standard-Standorte
    static var defaultLocations: [Location] {
        [
            Location(
                name: "Hauptlager",
                descriptionText: "Zentrales Lager für alle Geräte",
                iconName: "building.2.fill",
                colorHex: "007AFF",
                sortOrder: 1
            ),
            Location(
                name: "Außenlager",
                descriptionText: "Sekundäres Lager",
                iconName: "shippingbox.fill",
                colorHex: "FF9500",
                sortOrder: 2
            ),
            Location(
                name: "Werkstatt",
                descriptionText: "Für Reparaturen und Wartung",
                iconName: "wrench.and.screwdriver.fill",
                colorHex: "5856D6",
                sortOrder: 3
            ),
            Location(
                name: "Ausgeliehen",
                descriptionText: "Gerät ist beim Kunden",
                iconName: "arrow.right.circle.fill",
                colorHex: "34C759",
                sortOrder: 4
            )
        ]
    }
}
