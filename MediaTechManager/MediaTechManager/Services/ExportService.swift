//
//  ExportService.swift
//  MediaTechManager
//
//  Datenexport (CSV, JSON)
//

import Foundation
import UniformTypeIdentifiers

enum ExportService {

    // MARK: - Export Format

    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case json = "JSON"

        var fileExtension: String {
            rawValue.lowercased()
        }

        var utType: UTType {
            switch self {
            case .csv:
                return .commaSeparatedText
            case .json:
                return .json
            }
        }

        var mimeType: String {
            switch self {
            case .csv:
                return "text/csv"
            case .json:
                return "application/json"
            }
        }
    }

    // MARK: - Equipment Export

    /// Exportiert Geräte als CSV
    static func exportEquipmentAsCSV(_ equipment: [Equipment]) -> Data? {
        var csv = "Inventarnummer;Name;Hersteller;Modell;Seriennummer;Kategorie;Zustand;Standort;Kaufpreis;Tagesmiete;Verfügbar\n"

        for item in equipment {
            let row = [
                item.inventoryNumber,
                item.name,
                item.manufacturer,
                item.model,
                item.serialNumber,
                item.category?.name ?? "",
                item.condition?.name ?? "",
                item.location?.name ?? "",
                item.purchasePrice.map { String(format: "%.2f", $0) } ?? "",
                item.dailyRate.map { String(format: "%.2f", $0) } ?? "",
                item.isAvailable ? "Ja" : "Nein"
            ]

            csv += row.map { escapeCSV($0) }.joined(separator: ";") + "\n"
        }

        return csv.data(using: .utf8)
    }

    /// Exportiert Geräte als JSON
    static func exportEquipmentAsJSON(_ equipment: [Equipment]) -> Data? {
        let exportData = equipment.map { item -> [String: Any] in
            var dict: [String: Any] = [
                "inventoryNumber": item.inventoryNumber,
                "name": item.name,
                "manufacturer": item.manufacturer,
                "model": item.model,
                "serialNumber": item.serialNumber,
                "isAvailable": item.isAvailable,
                "isActive": item.isActive,
                "createdAt": ISO8601DateFormatter().string(from: item.createdAt),
                "updatedAt": ISO8601DateFormatter().string(from: item.updatedAt)
            ]

            if let category = item.category {
                dict["category"] = category.name
            }
            if let condition = item.condition {
                dict["condition"] = condition.name
            }
            if let location = item.location {
                dict["location"] = location.name
            }
            if let price = item.purchasePrice {
                dict["purchasePrice"] = price
            }
            if let rate = item.dailyRate {
                dict["dailyRate"] = rate
            }
            if !item.notes.isEmpty {
                dict["notes"] = item.notes
            }

            return dict
        }

        return try? JSONSerialization.data(
            withJSONObject: ["equipment": exportData, "exportDate": ISO8601DateFormatter().string(from: Date())],
            options: [.prettyPrinted, .sortedKeys]
        )
    }

    // MARK: - Customer Export

    /// Exportiert Kunden als CSV
    static func exportCustomersAsCSV(_ customers: [Customer]) -> Data? {
        var csv = "Kundennummer;Vorname;Nachname;Firma;E-Mail;Telefon;Mobil;Straße;PLZ;Stadt;Land;Kundentyp\n"

        for customer in customers {
            let row = [
                customer.customerNumber ?? "",
                customer.firstName,
                customer.lastName,
                customer.company ?? "",
                customer.email,
                customer.phone ?? "",
                customer.mobile ?? "",
                customer.street ?? "",
                customer.zipCode ?? "",
                customer.city ?? "",
                customer.country ?? "",
                customer.customerType.displayName
            ]

            csv += row.map { escapeCSV($0) }.joined(separator: ";") + "\n"
        }

        return csv.data(using: .utf8)
    }

    /// Exportiert Kunden als JSON
    static func exportCustomersAsJSON(_ customers: [Customer]) -> Data? {
        let exportData = customers.map { customer -> [String: Any] in
            var dict: [String: Any] = [
                "firstName": customer.firstName,
                "lastName": customer.lastName,
                "email": customer.email,
                "customerType": customer.customerType.rawValue,
                "createdAt": ISO8601DateFormatter().string(from: customer.createdAt),
                "updatedAt": ISO8601DateFormatter().string(from: customer.updatedAt)
            ]

            if let number = customer.customerNumber {
                dict["customerNumber"] = number
            }
            if let company = customer.company {
                dict["company"] = company
            }
            if let phone = customer.phone {
                dict["phone"] = phone
            }
            if let mobile = customer.mobile {
                dict["mobile"] = mobile
            }
            if let street = customer.street {
                dict["street"] = street
            }
            if let zip = customer.zipCode {
                dict["zipCode"] = zip
            }
            if let city = customer.city {
                dict["city"] = city
            }
            if let country = customer.country {
                dict["country"] = country
            }
            if !customer.notes.isEmpty {
                dict["notes"] = customer.notes
            }

            return dict
        }

        return try? JSONSerialization.data(
            withJSONObject: ["customers": exportData, "exportDate": ISO8601DateFormatter().string(from: Date())],
            options: [.prettyPrinted, .sortedKeys]
        )
    }

    // MARK: - Rental Export

    /// Exportiert Ausleihen als CSV
    static func exportRentalsAsCSV(_ rentals: [Rental]) -> Data? {
        var csv = "Ausleihnummer;Kunde;Status;Startdatum;Enddatum;Gesamtpreis;Kaution;Anzahl Geräte\n"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        for rental in rentals {
            let row = [
                rental.rentalNumber,
                rental.customer?.fullName ?? "",
                rental.status.displayName,
                dateFormatter.string(from: rental.plannedStartDate),
                dateFormatter.string(from: rental.plannedEndDate),
                String(format: "%.2f", rental.totalPrice),
                String(format: "%.2f", rental.depositAmount),
                String(rental.items.count)
            ]

            csv += row.map { escapeCSV($0) }.joined(separator: ";") + "\n"
        }

        return csv.data(using: .utf8)
    }

    /// Exportiert Ausleihen als JSON
    static func exportRentalsAsJSON(_ rentals: [Rental]) -> Data? {
        let exportData = rentals.map { rental -> [String: Any] in
            var dict: [String: Any] = [
                "rentalNumber": rental.rentalNumber,
                "status": rental.status.rawValue,
                "plannedStartDate": ISO8601DateFormatter().string(from: rental.plannedStartDate),
                "plannedEndDate": ISO8601DateFormatter().string(from: rental.plannedEndDate),
                "totalPrice": rental.totalPrice,
                "depositAmount": rental.depositAmount,
                "depositPaid": rental.depositPaid,
                "depositReturned": rental.depositReturned,
                "createdAt": ISO8601DateFormatter().string(from: rental.createdAt)
            ]

            if let customer = rental.customer {
                dict["customer"] = [
                    "name": customer.fullName,
                    "email": customer.email
                ]
            }

            if let actualStart = rental.actualStartDate {
                dict["actualStartDate"] = ISO8601DateFormatter().string(from: actualStart)
            }
            if let actualEnd = rental.actualEndDate {
                dict["actualEndDate"] = ISO8601DateFormatter().string(from: actualEnd)
            }

            let items = rental.items.map { item -> [String: Any] in
                [
                    "equipment": item.equipment?.displayName ?? "Unbekannt",
                    "inventoryNumber": item.equipment?.inventoryNumber ?? "",
                    "quantity": item.quantity,
                    "days": item.days,
                    "dailyRate": item.dailyRate,
                    "totalPrice": item.totalPrice
                ]
            }
            dict["items"] = items

            return dict
        }

        return try? JSONSerialization.data(
            withJSONObject: ["rentals": exportData, "exportDate": ISO8601DateFormatter().string(from: Date())],
            options: [.prettyPrinted, .sortedKeys]
        )
    }

    // MARK: - Full Backup

    /// Erstellt ein vollständiges Backup aller Daten
    static func createFullBackup(
        equipment: [Equipment],
        customers: [Customer],
        rentals: [Rental],
        categories: [Category],
        conditions: [Condition],
        locations: [Location]
    ) -> Data? {
        let backup: [String: Any] = [
            "version": "1.0",
            "appName": "MediaTechManager",
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "data": [
                "equipmentCount": equipment.count,
                "customersCount": customers.count,
                "rentalsCount": rentals.count,
                "categoriesCount": categories.count,
                "conditionsCount": conditions.count,
                "locationsCount": locations.count
            ]
        ]

        return try? JSONSerialization.data(
            withJSONObject: backup,
            options: [.prettyPrinted, .sortedKeys]
        )
    }

    // MARK: - Helpers

    /// Escaped einen String für CSV (Semikolon-getrennt)
    private static func escapeCSV(_ string: String) -> String {
        if string.contains(";") || string.contains("\"") || string.contains("\n") {
            return "\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return string
    }

    /// Generiert einen Dateinamen für den Export
    static func generateFilename(prefix: String, format: ExportFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        return "\(prefix)_\(timestamp).\(format.fileExtension)"
    }
}

// MARK: - Export Document

import SwiftUI

struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .commaSeparatedText] }

    let data: Data
    let format: ExportService.ExportFormat

    init(data: Data, format: ExportService.ExportFormat) {
        self.data = data
        self.format = format
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
        format = .json
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
