//
//  MaintenanceRecord.swift
//  MediaTechManager
//
//  SwiftData Model - Wartungseinträge
//

import Foundation
import SwiftData

@Model
final class MaintenanceRecord {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Zugehöriges Gerät
    @Relationship(deleteRule: .nullify)
    var equipment: Equipment?

    /// Art der Wartung
    var maintenanceTypeRawValue: String

    var maintenanceType: MaintenanceType {
        get { MaintenanceType(rawValue: maintenanceTypeRawValue) ?? .routine }
        set { maintenanceTypeRawValue = newValue.rawValue }
    }

    /// Titel / Kurzbeschreibung
    var title: String

    /// Detaillierte Beschreibung
    var descriptionText: String

    /// Durchgeführt am
    var performedDate: Date

    /// Durchgeführt von
    var performedBy: String

    /// Kosten
    var cost: Double?

    /// Externe Werkstatt / Firma
    var externalProvider: String?

    /// Notizen
    var notes: String

    /// Nächste Wartung geplant
    var nextMaintenanceDate: Date?

    /// Erstellungsdatum
    var createdAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        equipment: Equipment? = nil,
        maintenanceType: MaintenanceType = .routine,
        title: String = "",
        descriptionText: String = "",
        performedDate: Date = Date(),
        performedBy: String = "",
        cost: Double? = nil,
        externalProvider: String? = nil,
        notes: String = "",
        nextMaintenanceDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.equipment = equipment
        self.maintenanceTypeRawValue = maintenanceType.rawValue
        self.title = title
        self.descriptionText = descriptionText
        self.performedDate = performedDate
        self.performedBy = performedBy
        self.cost = cost
        self.externalProvider = externalProvider
        self.notes = notes
        self.nextMaintenanceDate = nextMaintenanceDate
        self.createdAt = createdAt
    }
}

// MARK: - Identifiable

extension MaintenanceRecord: Identifiable {}

// MARK: - MaintenanceType Enum

enum MaintenanceType: String, CaseIterable, Codable {

    case routine = "Routinewartung"
    case repair = "Reparatur"
    case inspection = "Inspektion"
    case calibration = "Kalibrierung"
    case cleaning = "Reinigung"
    case firmware = "Firmware-Update"
    case other = "Sonstiges"

    var icon: String {
        switch self {
        case .routine:
            return "wrench.fill"
        case .repair:
            return "hammer.fill"
        case .inspection:
            return "magnifyingglass"
        case .calibration:
            return "slider.horizontal.3"
        case .cleaning:
            return "sparkles"
        case .firmware:
            return "arrow.down.circle.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }

    var displayName: String {
        rawValue
    }
}
