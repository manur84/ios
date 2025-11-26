//
//  Category.swift
//  MediaTechManager
//
//  SwiftData Model - Kategorien
//

import Foundation
import SwiftData

@Model
final class Category {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Name der Kategorie
    var name: String

    /// Beschreibung
    var descriptionText: String

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
        iconName: String = "folder.fill",
        colorHex: String = "007AFF",
        sortOrder: Int = 0,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.iconName = iconName
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension Category: Identifiable {}

// MARK: - Predefined Categories

extension Category {

    /// Vordefinierte Standard-Kategorien
    static var defaultCategories: [Category] {
        [
            Category(name: "Kameras", iconName: "camera.fill", colorHex: "007AFF", sortOrder: 1),
            Category(name: "Objektive", iconName: "circle.circle", colorHex: "5856D6", sortOrder: 2),
            Category(name: "Licht", iconName: "lightbulb.fill", colorHex: "FF9500", sortOrder: 3),
            Category(name: "Audio", iconName: "waveform", colorHex: "34C759", sortOrder: 4),
            Category(name: "Stative", iconName: "triangle.fill", colorHex: "FF3B30", sortOrder: 5),
            Category(name: "Monitore", iconName: "display", colorHex: "5AC8FA", sortOrder: 6),
            Category(name: "Speicher", iconName: "sdcard.fill", colorHex: "AF52DE", sortOrder: 7),
            Category(name: "Kabel", iconName: "cable.connector", colorHex: "8E8E93", sortOrder: 8),
            Category(name: "Zubehör", iconName: "bag.fill", colorHex: "FF2D55", sortOrder: 9),
            Category(name: "Sonstiges", iconName: "ellipsis.circle.fill", colorHex: "636366", sortOrder: 100)
        ]
    }
}
