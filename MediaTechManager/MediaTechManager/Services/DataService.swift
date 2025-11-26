//
//  DataService.swift
//  MediaTechManager
//
//  Daten-Service für Seed-Daten und Initialisierung
//

import Foundation
import SwiftData

enum DataService {

    // MARK: - Seed Data

    /// Erstellt Standard-Kategorien wenn keine vorhanden sind
    @MainActor
    static func seedCategories(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>()

        do {
            let count = try context.fetchCount(descriptor)
            guard count == 0 else { return }

            let defaultCategories = [
                Category(name: "Kameras", iconName: "camera.fill", colorHex: "007AFF", sortOrder: 0),
                Category(name: "Objektive", iconName: "camera.aperture", colorHex: "5856D6", sortOrder: 1),
                Category(name: "Licht", iconName: "lightbulb.fill", colorHex: "FFD60A", sortOrder: 2),
                Category(name: "Audio", iconName: "mic.fill", colorHex: "FF9500", sortOrder: 3),
                Category(name: "Stative", iconName: "triangle", colorHex: "8E8E93", sortOrder: 4),
                Category(name: "Zubehör", iconName: "shippingbox", colorHex: "34C759", sortOrder: 5),
                Category(name: "Speichermedien", iconName: "memorychip", colorHex: "00C7BE", sortOrder: 6),
                Category(name: "Kabel", iconName: "cable.connector", colorHex: "AF52DE", sortOrder: 7)
            ]

            for category in defaultCategories {
                context.insert(category)
            }

            try context.save()
            Logger.info("Seeded \(defaultCategories.count) default categories")

        } catch {
            Logger.error(error, message: "Failed to seed categories")
        }
    }

    /// Erstellt Standard-Zustände wenn keine vorhanden sind
    @MainActor
    static func seedConditions(context: ModelContext) {
        let descriptor = FetchDescriptor<Condition>()

        do {
            let count = try context.fetchCount(descriptor)
            guard count == 0 else { return }

            let defaultConditions = [
                Condition(name: "Neuwertig", iconName: "star.fill", colorHex: "34C759", sortOrder: 0),
                Condition(name: "Sehr gut", iconName: "hand.thumbsup.fill", colorHex: "007AFF", sortOrder: 1),
                Condition(name: "Gut", iconName: "checkmark.seal.fill", colorHex: "00C7BE", sortOrder: 2),
                Condition(name: "Gebraucht", iconName: "clock.fill", colorHex: "FFD60A", sortOrder: 3),
                Condition(name: "Reparaturbedürftig", iconName: "wrench.fill", colorHex: "FF9500", sortOrder: 4),
                Condition(name: "Defekt", iconName: "xmark.seal.fill", colorHex: "FF3B30", sortOrder: 5)
            ]

            for condition in defaultConditions {
                context.insert(condition)
            }

            try context.save()
            Logger.info("Seeded \(defaultConditions.count) default conditions")

        } catch {
            Logger.error(error, message: "Failed to seed conditions")
        }
    }

    /// Erstellt Standard-Standorte wenn keine vorhanden sind
    @MainActor
    static func seedLocations(context: ModelContext) {
        let descriptor = FetchDescriptor<Location>()

        do {
            let count = try context.fetchCount(descriptor)
            guard count == 0 else { return }

            let defaultLocations = [
                Location(name: "Hauptlager", iconName: "building.2.fill", colorHex: "007AFF", sortOrder: 0),
                Location(name: "Außenlager", iconName: "archivebox.fill", colorHex: "5856D6", sortOrder: 1),
                Location(name: "Beim Kunden", iconName: "person.fill", colorHex: "FF9500", sortOrder: 2),
                Location(name: "In Reparatur", iconName: "wrench.fill", colorHex: "FF3B30", sortOrder: 3),
                Location(name: "Unterwegs", iconName: "car.fill", colorHex: "34C759", sortOrder: 4)
            ]

            for location in defaultLocations {
                context.insert(location)
            }

            try context.save()
            Logger.info("Seeded \(defaultLocations.count) default locations")

        } catch {
            Logger.error(error, message: "Failed to seed locations")
        }
    }

    /// Initialisiert alle Seed-Daten
    @MainActor
    static func initializeSeedData(context: ModelContext) {
        seedCategories(context: context)
        seedConditions(context: context)
        seedLocations(context: context)
    }

    // MARK: - Demo Data (for Development)

    #if DEBUG
    /// Erstellt Demo-Daten für Entwicklung und Tests
    @MainActor
    static func createDemoData(context: ModelContext) {
        // Ensure seed data exists
        initializeSeedData(context: context)

        // Create demo customers
        let demoCustomers = [
            Customer(firstName: "Max", lastName: "Mustermann", email: "max@example.com", customerType: .private),
            Customer(firstName: "Anna", lastName: "Schmidt", email: "anna@firma.de", customerType: .business),
            Customer(firstName: "Thomas", lastName: "Müller", email: "thomas@uni.de", customerType: .educational)
        ]

        demoCustomers[0].phone = "+49 123 456789"
        demoCustomers[1].company = "Media Productions GmbH"
        demoCustomers[1].phone = "+49 987 654321"

        for customer in demoCustomers {
            context.insert(customer)
        }

        // Create demo equipment
        let demoEquipment = [
            Equipment(name: "Canon EOS R5"),
            Equipment(name: "Sony A7S III"),
            Equipment(name: "Canon RF 24-70mm f/2.8L"),
            Equipment(name: "ARRI SkyPanel S60"),
            Equipment(name: "Sennheiser MKH 416")
        ]

        demoEquipment[0].manufacturer = "Canon"
        demoEquipment[0].model = "EOS R5"
        demoEquipment[0].inventoryNumber = "CAM-001"
        demoEquipment[0].dailyRate = 150

        demoEquipment[1].manufacturer = "Sony"
        demoEquipment[1].model = "A7S III"
        demoEquipment[1].inventoryNumber = "CAM-002"
        demoEquipment[1].dailyRate = 120

        demoEquipment[2].manufacturer = "Canon"
        demoEquipment[2].model = "RF 24-70mm f/2.8L IS USM"
        demoEquipment[2].inventoryNumber = "OBJ-001"
        demoEquipment[2].dailyRate = 50

        demoEquipment[3].manufacturer = "ARRI"
        demoEquipment[3].model = "SkyPanel S60-C"
        demoEquipment[3].inventoryNumber = "LGT-001"
        demoEquipment[3].dailyRate = 80

        demoEquipment[4].manufacturer = "Sennheiser"
        demoEquipment[4].model = "MKH 416"
        demoEquipment[4].inventoryNumber = "AUD-001"
        demoEquipment[4].dailyRate = 30

        for equipment in demoEquipment {
            context.insert(equipment)
        }

        do {
            try context.save()
            Logger.info("Created demo data successfully")
        } catch {
            Logger.error(error, message: "Failed to create demo data")
        }
    }
    #endif
}
