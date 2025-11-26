//
//  Equipment.swift
//  MediaTechManager
//
//  SwiftData Model - Geräte/Equipment
//

import Foundation
import SwiftData

@Model
final class Equipment {

    // MARK: - Identifikation

    /// Eindeutige ID
    var id: UUID

    /// Inventarnummer (z.B. "CAM-001")
    var inventoryNumber: String

    /// Seriennummer des Herstellers
    var serialNumber: String

    /// Barcode (falls vorhanden)
    var barcode: String?

    // MARK: - Beschreibung

    /// Name des Geräts
    var name: String

    /// Hersteller
    var manufacturer: String

    /// Modellbezeichnung
    var model: String

    /// Beschreibung
    var descriptionText: String

    // MARK: - Klassifizierung

    /// Kategorie
    @Relationship(deleteRule: .nullify)
    var category: Category?

    /// Zustand
    @Relationship(deleteRule: .nullify)
    var condition: Condition?

    /// Standort
    @Relationship(deleteRule: .nullify)
    var location: Location?

    /// Tags
    @Relationship(deleteRule: .nullify)
    var tags: [Tag]

    // MARK: - Finanzen

    /// Kaufpreis
    var purchasePrice: Double?

    /// Kaufdatum
    var purchaseDate: Date?

    /// Tagesmiete
    var dailyRate: Double?

    /// Ersatzwert
    var replacementValue: Double?

    // MARK: - Bilder

    /// Gespeicherte Bilder als Data
    var images: [Data]

    // MARK: - Status

    /// Ist verfügbar für Ausleihe
    var isAvailable: Bool

    /// Ist aktiv (nicht ausgemustert)
    var isActive: Bool

    // MARK: - Wartung

    /// Letztes Wartungsdatum
    var lastMaintenanceDate: Date?

    /// Nächstes Wartungsdatum
    var nextMaintenanceDate: Date?

    /// Wartungsintervall in Tagen
    var maintenanceIntervalDays: Int?

    // MARK: - Notizen

    /// Interne Notizen
    var notes: String

    // MARK: - Beziehungen

    /// Ausleihen dieses Geräts
    @Relationship(deleteRule: .cascade, inverse: \RentalItem.equipment)
    var rentalItems: [RentalItem]

    /// Wartungseinträge
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceRecord.equipment)
    var maintenanceRecords: [MaintenanceRecord]

    /// Schadensberichte
    @Relationship(deleteRule: .cascade, inverse: \DamageReport.equipment)
    var damageReports: [DamageReport]

    // MARK: - Metadaten

    /// Erstellungsdatum
    var createdAt: Date

    /// Letztes Änderungsdatum
    var updatedAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        inventoryNumber: String = "",
        serialNumber: String = "",
        barcode: String? = nil,
        name: String,
        manufacturer: String = "",
        model: String = "",
        descriptionText: String = "",
        category: Category? = nil,
        condition: Condition? = nil,
        location: Location? = nil,
        tags: [Tag] = [],
        purchasePrice: Double? = nil,
        purchaseDate: Date? = nil,
        dailyRate: Double? = nil,
        replacementValue: Double? = nil,
        images: [Data] = [],
        isAvailable: Bool = true,
        isActive: Bool = true,
        lastMaintenanceDate: Date? = nil,
        nextMaintenanceDate: Date? = nil,
        maintenanceIntervalDays: Int? = nil,
        notes: String = "",
        rentalItems: [RentalItem] = [],
        maintenanceRecords: [MaintenanceRecord] = [],
        damageReports: [DamageReport] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.inventoryNumber = inventoryNumber
        self.serialNumber = serialNumber
        self.barcode = barcode
        self.name = name
        self.manufacturer = manufacturer
        self.model = model
        self.descriptionText = descriptionText
        self.category = category
        self.condition = condition
        self.location = location
        self.tags = tags
        self.purchasePrice = purchasePrice
        self.purchaseDate = purchaseDate
        self.dailyRate = dailyRate
        self.replacementValue = replacementValue
        self.images = images
        self.isAvailable = isAvailable
        self.isActive = isActive
        self.lastMaintenanceDate = lastMaintenanceDate
        self.nextMaintenanceDate = nextMaintenanceDate
        self.maintenanceIntervalDays = maintenanceIntervalDays
        self.notes = notes
        self.rentalItems = rentalItems
        self.maintenanceRecords = maintenanceRecords
        self.damageReports = damageReports
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Computed Properties

extension Equipment {

    /// Vollständiger Anzeigename
    var displayName: String {
        if manufacturer.isEmpty {
            return name
        }
        return "\(manufacturer) \(name)"
    }

    /// QR-Code Inhalt
    var qrCodeContent: String {
        "MTM://equipment/\(id.uuidString)"
    }

    /// Ist Wartung fällig?
    var isMaintenanceDue: Bool {
        guard let nextDate = nextMaintenanceDate else { return false }
        return nextDate <= Date()
    }

    /// Tage bis zur nächsten Wartung
    var daysUntilMaintenance: Int? {
        guard let nextDate = nextMaintenanceDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: nextDate).day
    }

    /// Primärbild
    var primaryImage: Data? {
        images.first
    }

    /// Hat Bilder
    var hasImages: Bool {
        !images.isEmpty
    }

    /// Anzahl der Ausleihen
    var totalRentals: Int {
        rentalItems.count
    }
}

// MARK: - Hashable & Identifiable

extension Equipment: Identifiable {}

extension Equipment {
    /// Aktualisiert das Änderungsdatum
    func touch() {
        updatedAt = Date()
    }
}
