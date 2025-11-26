//
//  DamageReport.swift
//  MediaTechManager
//
//  SwiftData Model - Schadensberichte
//

import Foundation
import SwiftData

@Model
final class DamageReport {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Zugehöriges Gerät
    @Relationship(deleteRule: .nullify)
    var equipment: Equipment?

    /// Zugehörige Ausleihe (falls relevant)
    var rentalId: UUID?

    /// Art des Schadens
    var damageTypeRawValue: String

    var damageType: DamageType {
        get { DamageType(rawValue: damageTypeRawValue) ?? .other }
        set { damageTypeRawValue = newValue.rawValue }
    }

    /// Titel / Kurzbeschreibung
    var title: String

    /// Detaillierte Beschreibung des Schadens
    var descriptionText: String

    /// Datum der Feststellung
    var reportedDate: Date

    /// Gemeldet von
    var reportedBy: String

    /// Fotos des Schadens
    var photos: [Data]

    /// Geschätzte Reparaturkosten
    var estimatedRepairCost: Double?

    /// Tatsächliche Reparaturkosten
    var actualRepairCost: Double?

    /// Ist repariert
    var isRepaired: Bool

    /// Reparaturdatum
    var repairDate: Date?

    /// Reparatur durchgeführt von
    var repairedBy: String?

    /// Notizen
    var notes: String

    /// Erstellungsdatum
    var createdAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        equipment: Equipment? = nil,
        rentalId: UUID? = nil,
        damageType: DamageType = .other,
        title: String = "",
        descriptionText: String = "",
        reportedDate: Date = Date(),
        reportedBy: String = "",
        photos: [Data] = [],
        estimatedRepairCost: Double? = nil,
        actualRepairCost: Double? = nil,
        isRepaired: Bool = false,
        repairDate: Date? = nil,
        repairedBy: String? = nil,
        notes: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.equipment = equipment
        self.rentalId = rentalId
        self.damageTypeRawValue = damageType.rawValue
        self.title = title
        self.descriptionText = descriptionText
        self.reportedDate = reportedDate
        self.reportedBy = reportedBy
        self.photos = photos
        self.estimatedRepairCost = estimatedRepairCost
        self.actualRepairCost = actualRepairCost
        self.isRepaired = isRepaired
        self.repairDate = repairDate
        self.repairedBy = repairedBy
        self.notes = notes
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension DamageReport: Identifiable {}

// MARK: - DamageType Enum

enum DamageType: String, CaseIterable, Codable {

    case cosmetic = "Kosmetisch"
    case functional = "Funktional"
    case structural = "Strukturell"
    case electrical = "Elektrisch"
    case water = "Wasserschaden"
    case impact = "Stoßschaden"
    case wear = "Verschleiß"
    case missing = "Fehlende Teile"
    case other = "Sonstiges"

    var icon: String {
        switch self {
        case .cosmetic:
            return "paintbrush.fill"
        case .functional:
            return "gearshape.fill"
        case .structural:
            return "square.on.square.dashed"
        case .electrical:
            return "bolt.fill"
        case .water:
            return "drop.fill"
        case .impact:
            return "burst.fill"
        case .wear:
            return "clock.fill"
        case .missing:
            return "questionmark.circle.fill"
        case .other:
            return "exclamationmark.circle.fill"
        }
    }

    var displayName: String {
        rawValue
    }

    var severity: DamageSeverity {
        switch self {
        case .cosmetic, .wear:
            return .minor
        case .functional, .missing:
            return .moderate
        case .structural, .electrical, .water, .impact:
            return .severe
        case .other:
            return .moderate
        }
    }
}

enum DamageSeverity: String, CaseIterable {
    case minor = "Gering"
    case moderate = "Mittel"
    case severe = "Schwer"

    var color: String {
        switch self {
        case .minor:
            return "FF9500"
        case .moderate:
            return "FF3B30"
        case .severe:
            return "8B0000"
        }
    }
}
