//
//  Rental.swift
//  MediaTechManager
//
//  SwiftData Model - Ausleihen
//

import Foundation
import SwiftData

@Model
final class Rental {

    // MARK: - Identifikation

    /// Eindeutige ID
    var id: UUID

    /// Ausleihnummer
    var rentalNumber: String

    // MARK: - Zeitraum

    /// Geplantes Startdatum
    var plannedStartDate: Date

    /// Geplantes Enddatum
    var plannedEndDate: Date

    /// Tatsächliches Startdatum (Übergabe)
    var actualStartDate: Date?

    /// Tatsächliches Enddatum (Rückgabe)
    var actualEndDate: Date?

    // MARK: - Status

    /// Aktueller Status
    var statusRawValue: String

    var status: RentalStatus {
        get { RentalStatus(rawValue: statusRawValue) ?? .reserved }
        set { statusRawValue = newValue.rawValue }
    }

    // MARK: - Beziehungen

    /// Kunde
    @Relationship(deleteRule: .nullify)
    var customer: Customer?

    /// Ausgeliehene Geräte
    @Relationship(deleteRule: .cascade, inverse: \RentalItem.rental)
    var items: [RentalItem]

    // MARK: - Finanzen

    /// Gesamtpreis
    var totalPrice: Double

    /// Kaution
    var depositAmount: Double

    /// Kaution erhalten
    var depositReceived: Bool

    /// Kaution zurückgegeben
    var depositReturned: Bool

    /// Rabatt in Prozent
    var discountPercent: Double

    /// Zusätzliche Kosten
    var additionalCosts: Double

    /// Zusatzkosten Beschreibung
    var additionalCostsDescription: String

    // MARK: - Protokolle

    /// Übergabeprotokoll Notizen
    var handoverNotes: String

    /// Übergabe Unterschrift (als Data)
    var handoverSignature: Data?

    /// Übergabedatum
    var handoverDate: Date?

    /// Rückgabeprotokoll Notizen
    var returnNotes: String

    /// Rückgabe Unterschrift (als Data)
    var returnSignature: Data?

    /// Rückgabedatum
    var returnDate: Date?

    // MARK: - Zusätzliche Informationen

    /// Verwendungszweck
    var purpose: String

    /// Veranstaltungsort
    var eventLocation: String

    /// Interne Notizen
    var notes: String

    // MARK: - Metadaten

    /// Erstellungsdatum
    var createdAt: Date

    /// Letztes Änderungsdatum
    var updatedAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        rentalNumber: String = "",
        plannedStartDate: Date = Date(),
        plannedEndDate: Date = Date().addingTimeInterval(86400),
        actualStartDate: Date? = nil,
        actualEndDate: Date? = nil,
        status: RentalStatus = .reserved,
        customer: Customer? = nil,
        items: [RentalItem] = [],
        totalPrice: Double = 0,
        depositAmount: Double = 0,
        depositReceived: Bool = false,
        depositReturned: Bool = false,
        discountPercent: Double = 0,
        additionalCosts: Double = 0,
        additionalCostsDescription: String = "",
        handoverNotes: String = "",
        handoverSignature: Data? = nil,
        handoverDate: Date? = nil,
        returnNotes: String = "",
        returnSignature: Data? = nil,
        returnDate: Date? = nil,
        purpose: String = "",
        eventLocation: String = "",
        notes: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.rentalNumber = rentalNumber
        self.plannedStartDate = plannedStartDate
        self.plannedEndDate = plannedEndDate
        self.actualStartDate = actualStartDate
        self.actualEndDate = actualEndDate
        self.statusRawValue = status.rawValue
        self.customer = customer
        self.items = items
        self.totalPrice = totalPrice
        self.depositAmount = depositAmount
        self.depositReceived = depositReceived
        self.depositReturned = depositReturned
        self.discountPercent = discountPercent
        self.additionalCosts = additionalCosts
        self.additionalCostsDescription = additionalCostsDescription
        self.handoverNotes = handoverNotes
        self.handoverSignature = handoverSignature
        self.handoverDate = handoverDate
        self.returnNotes = returnNotes
        self.returnSignature = returnSignature
        self.returnDate = returnDate
        self.purpose = purpose
        self.eventLocation = eventLocation
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Computed Properties

extension Rental {

    /// Anzahl der Tage
    var numberOfDays: Int {
        let start = actualStartDate ?? plannedStartDate
        let end = actualEndDate ?? plannedEndDate
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return max(1, days)
    }

    /// Ist überfällig
    var isOverdue: Bool {
        guard status == .active else { return false }
        return plannedEndDate < Date()
    }

    /// Tage überfällig
    var daysOverdue: Int {
        guard isOverdue else { return 0 }
        return Calendar.current.dateComponents([.day], from: plannedEndDate, to: Date()).day ?? 0
    }

    /// Zeitraum als String
    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "de_DE")

        let start = formatter.string(from: plannedStartDate)
        let end = formatter.string(from: plannedEndDate)

        return "\(start) - \(end)"
    }

    /// Berechnet Gesamtpreis aus Items
    var calculatedTotalPrice: Double {
        let itemsTotal = items.reduce(0) { $0 + $1.totalPrice }
        let withDiscount = itemsTotal * (1 - discountPercent / 100)
        return withDiscount + additionalCosts
    }

    /// Anzahl der Geräte
    var equipmentCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    /// Hat Übergabeprotokoll
    var hasHandoverProtocol: Bool {
        handoverSignature != nil || !handoverNotes.isEmpty
    }

    /// Hat Rückgabeprotokoll
    var hasReturnProtocol: Bool {
        returnSignature != nil || !returnNotes.isEmpty
    }

    /// Status aktualisieren basierend auf Daten
    func updateStatus() {
        if actualEndDate != nil {
            status = .returned
        } else if actualStartDate != nil {
            status = isOverdue ? .overdue : .active
        } else if plannedStartDate <= Date() {
            status = .active
        }
        touch()
    }
}

// MARK: - Identifiable

extension Rental: Identifiable {}

extension Rental {
    /// Aktualisiert das Änderungsdatum
    func touch() {
        updatedAt = Date()
    }
}

// MARK: - RentalItem (Ausleih-Position)

@Model
final class RentalItem {

    /// Eindeutige ID
    var id: UUID

    /// Zugehörige Ausleihe
    @Relationship(deleteRule: .nullify)
    var rental: Rental?

    /// Ausgeliehenes Gerät
    @Relationship(deleteRule: .nullify)
    var equipment: Equipment?

    /// Menge
    var quantity: Int

    /// Einzelpreis pro Tag
    var dailyRate: Double

    /// Anzahl Tage
    var days: Int

    /// Notizen zum Gerät bei Übergabe
    var handoverCondition: String

    /// Notizen zum Gerät bei Rückgabe
    var returnCondition: String

    /// Schaden bei Rückgabe festgestellt
    var hasDamage: Bool

    /// Erstellungsdatum
    var createdAt: Date

    init(
        id: UUID = UUID(),
        rental: Rental? = nil,
        equipment: Equipment? = nil,
        quantity: Int = 1,
        dailyRate: Double = 0,
        days: Int = 1,
        handoverCondition: String = "",
        returnCondition: String = "",
        hasDamage: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.rental = rental
        self.equipment = equipment
        self.quantity = quantity
        self.dailyRate = dailyRate
        self.days = days
        self.handoverCondition = handoverCondition
        self.returnCondition = returnCondition
        self.hasDamage = hasDamage
        self.createdAt = createdAt
    }

    /// Gesamtpreis für dieses Item
    var totalPrice: Double {
        Double(quantity) * dailyRate * Double(days)
    }
}

extension RentalItem: Identifiable {}
