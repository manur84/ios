//
//  Tag.swift
//  MediaTechManager
//
//  SwiftData Model - Tags
//

import Foundation
import SwiftData

@Model
final class Tag {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Name des Tags
    var name: String

    /// Farbe als Hex-String
    var colorHex: String

    /// Ist aktiv
    var isActive: Bool

    /// Erstellungsdatum
    var createdAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String = "007AFF",
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension Tag: Identifiable {}

// MARK: - Equatable

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Predefined Tags

extension Tag {

    /// Vordefinierte Standard-Tags
    static var defaultTags: [Tag] {
        [
            Tag(name: "4K", colorHex: "007AFF"),
            Tag(name: "8K", colorHex: "5856D6"),
            Tag(name: "Vollformat", colorHex: "34C759"),
            Tag(name: "APS-C", colorHex: "FF9500"),
            Tag(name: "Wireless", colorHex: "5AC8FA"),
            Tag(name: "Akku", colorHex: "FF2D55"),
            Tag(name: "Premium", colorHex: "AF52DE"),
            Tag(name: "Outdoor", colorHex: "00C7BE")
        ]
    }
}
