//
//  Customer.swift
//  MediaTechManager
//
//  SwiftData Model - Kunden
//

import Foundation
import SwiftData

@Model
final class Customer {

    // MARK: - Identifikation

    /// Eindeutige ID
    var id: UUID

    /// Kundennummer
    var customerNumber: String

    // MARK: - Persönliche Daten

    /// Vorname
    var firstName: String

    /// Nachname
    var lastName: String

    /// Firma/Organisation
    var company: String?

    // MARK: - Kontaktdaten

    /// E-Mail Adresse
    var email: String

    /// Telefonnummer
    var phone: String

    /// Mobilnummer
    var mobile: String?

    // MARK: - Adresse

    /// Straße und Hausnummer
    var street: String

    /// Postleitzahl
    var postalCode: String

    /// Stadt
    var city: String

    /// Land
    var country: String

    // MARK: - Zusätzliche Informationen

    /// Interne Notizen
    var notes: String

    /// Ausweis-Typ (z.B. "Personalausweis")
    var identificationDocumentType: String?

    /// Ausweis-Nummer
    var identificationDocumentNumber: String?

    // MARK: - Status

    /// Ist aktiv
    var isActive: Bool

    /// Ist als Stammkunde markiert
    var isRegularCustomer: Bool

    // MARK: - Finanzen

    /// Kreditlimit
    var creditLimit: Double?

    /// Kaution hinterlegt
    var depositAmount: Double?

    // MARK: - Beziehungen

    /// Ausleihen dieses Kunden
    @Relationship(deleteRule: .nullify, inverse: \Rental.customer)
    var rentals: [Rental]

    // MARK: - Metadaten

    /// Erstellungsdatum
    var createdAt: Date

    /// Letztes Änderungsdatum
    var updatedAt: Date

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        customerNumber: String = "",
        firstName: String = "",
        lastName: String = "",
        company: String? = nil,
        email: String = "",
        phone: String = "",
        mobile: String? = nil,
        street: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "Deutschland",
        notes: String = "",
        identificationDocumentType: String? = nil,
        identificationDocumentNumber: String? = nil,
        isActive: Bool = true,
        isRegularCustomer: Bool = false,
        creditLimit: Double? = nil,
        depositAmount: Double? = nil,
        rentals: [Rental] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.customerNumber = customerNumber
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.email = email
        self.phone = phone
        self.mobile = mobile
        self.street = street
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.notes = notes
        self.identificationDocumentType = identificationDocumentType
        self.identificationDocumentNumber = identificationDocumentNumber
        self.isActive = isActive
        self.isRegularCustomer = isRegularCustomer
        self.creditLimit = creditLimit
        self.depositAmount = depositAmount
        self.rentals = rentals
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Computed Properties

extension Customer {

    /// Vollständiger Name
    var fullName: String {
        let name = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? "Unbenannt" : name
    }

    /// Anzeigename (mit Firma wenn vorhanden)
    var displayName: String {
        if let company = company, !company.isEmpty {
            return "\(fullName) (\(company))"
        }
        return fullName
    }

    /// Vollständige Adresse
    var fullAddress: String {
        var parts: [String] = []

        if !street.isEmpty {
            parts.append(street)
        }

        let cityLine = [postalCode, city].filter { !$0.isEmpty }.joined(separator: " ")
        if !cityLine.isEmpty {
            parts.append(cityLine)
        }

        if !country.isEmpty && country != "Deutschland" {
            parts.append(country)
        }

        return parts.joined(separator: "\n")
    }

    /// Primäre Telefonnummer
    var primaryPhone: String {
        mobile ?? phone
    }

    /// Hat Kontaktdaten
    var hasContactInfo: Bool {
        !email.isEmpty || !phone.isEmpty || mobile != nil
    }

    /// Anzahl der Ausleihen
    var totalRentals: Int {
        rentals.count
    }

    /// Anzahl der aktiven Ausleihen
    var activeRentals: Int {
        rentals.filter { $0.status == .active || $0.status == .overdue }.count
    }

    /// Hat aktive Ausleihen
    var hasActiveRentals: Bool {
        activeRentals > 0
    }

    /// Initialen für Avatar
    var initials: String {
        let firstInitial = firstName.first.map(String.init) ?? ""
        let lastInitial = lastName.first.map(String.init) ?? ""
        return "\(firstInitial)\(lastInitial)".uppercased()
    }
}

// MARK: - Identifiable

extension Customer: Identifiable {}

extension Customer {
    /// Aktualisiert das Änderungsdatum
    func touch() {
        updatedAt = Date()
    }
}
