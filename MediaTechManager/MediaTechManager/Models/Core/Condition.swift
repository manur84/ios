//
//  Condition.swift
//  MediaTechManager
//
//  SwiftData Model - Zustände
//

import Foundation
import SwiftData

@Model
final class Condition {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Name des Zustands
    var name: String

    /// Beschreibung
    var descriptionText: String

    /// SF Symbol Name für Icon
    var iconName: String

    /// Farbe als Hex-String
    var colorHex: String

    /// Sortierreihenfolge (niedrig = besser)
    var sortOrder: Int

    /// Kann ausgeliehen werden
    var canBeRented: Bool

    /// Ist aktiv
    var isActive: Bool

    /// Erstellungsdatum
    var createdAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        name: String,
        descriptionText: String = "",
        iconName: String = "checkmark.circle.fill",
        colorHex: String = "34C759",
        sortOrder: Int = 0,
        canBeRented: Bool = true,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.iconName = iconName
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.canBeRented = canBeRented
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension Condition: Identifiable {}

// MARK: - Predefined Conditions

extension Condition {

    /// Vordefinierte Standard-Zustände
    static var defaultConditions: [Condition] {
        [
            Condition(
                name: "Neu",
                descriptionText: "Neu und unbenutzt",
                iconName: "sparkles",
                colorHex: "007AFF",
                sortOrder: 1,
                canBeRented: true
            ),
            Condition(
                name: "Sehr gut",
                descriptionText: "Kaum Gebrauchsspuren",
                iconName: "checkmark.circle.fill",
                colorHex: "34C759",
                sortOrder: 2,
                canBeRented: true
            ),
            Condition(
                name: "Gut",
                descriptionText: "Normale Gebrauchsspuren",
                iconName: "checkmark.circle",
                colorHex: "5AC8FA",
                sortOrder: 3,
                canBeRented: true
            ),
            Condition(
                name: "Akzeptabel",
                descriptionText: "Deutliche Gebrauchsspuren, voll funktionsfähig",
                iconName: "minus.circle.fill",
                colorHex: "FF9500",
                sortOrder: 4,
                canBeRented: true
            ),
            Condition(
                name: "Beschädigt",
                descriptionText: "Sichtbare Schäden, Funktion eingeschränkt",
                iconName: "exclamationmark.triangle.fill",
                colorHex: "FF3B30",
                sortOrder: 5,
                canBeRented: false
            ),
            Condition(
                name: "Defekt",
                descriptionText: "Nicht funktionsfähig",
                iconName: "xmark.circle.fill",
                colorHex: "FF3B30",
                sortOrder: 6,
                canBeRented: false
            ),
            Condition(
                name: "In Reparatur",
                descriptionText: "Wird derzeit repariert",
                iconName: "wrench.fill",
                colorHex: "AF52DE",
                sortOrder: 7,
                canBeRented: false
            )
        ]
    }
}
