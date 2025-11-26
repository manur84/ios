//
//  BackupRestoreView.swift
//  MediaTechManager
//
//  Backup und Wiederherstellung
//

import SwiftUI
import SwiftData

struct BackupRestoreView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query private var equipment: [Equipment]
    @Query private var customers: [Customer]
    @Query private var rentals: [Rental]
    @Query private var categories: [Category]
    @Query private var conditions: [Condition]
    @Query private var locations: [Location]

    // MARK: - State

    @State private var isCreatingBackup = false
    @State private var showShareSheet = false
    @State private var backupURL: URL?
    @State private var showDeleteConfirmation = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                // Backup Section
                Section {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Backup erstellen", systemImage: "arrow.down.doc")
                            .font(.titleSmall)

                        Text("Sichern Sie alle Ihre Daten in einer Datei. Diese kann bei Bedarf wiederhergestellt werden.")
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xs)

                    Button {
                        createBackup()
                    } label: {
                        HStack {
                            if isCreatingBackup {
                                ProgressView()
                                    .padding(.trailing, Spacing.sm)
                            }
                            Text("Backup jetzt erstellen")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(isCreatingBackup)
                }

                // Statistics Section
                Section("Aktuelle Daten") {
                    StatRow(title: "Geräte", count: equipment.count, icon: "shippingbox")
                    StatRow(title: "Kunden", count: customers.count, icon: "person.2")
                    StatRow(title: "Ausleihen", count: rentals.count, icon: "arrow.left.arrow.right")
                    StatRow(title: "Kategorien", count: categories.count, icon: "folder")
                    StatRow(title: "Zustände", count: conditions.count, icon: "checkmark.seal")
                    StatRow(title: "Standorte", count: locations.count, icon: "mappin.circle")
                }

                // Restore Section
                Section {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Wiederherstellen", systemImage: "arrow.up.doc")
                            .font(.titleSmall)

                        Text("Die Wiederherstellung aus einem Backup wird in einer zukünftigen Version verfügbar sein.")
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xs)

                    Button {
                        // TODO: Implement restore
                        toastManager.info("Funktion kommt bald")
                    } label: {
                        HStack {
                            Text("Aus Backup wiederherstellen")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(true)
                }

                // Danger Zone
                Section {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Gefahrenzone", systemImage: "exclamationmark.triangle")
                            .font(.titleSmall)
                            .foregroundStyle(.red)

                        Text("Diese Aktionen können nicht rückgängig gemacht werden.")
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xs)

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Alle Daten löschen")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Backup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = backupURL {
                    ShareSheet(items: [url])
                }
            }
            .confirmationDialog(
                "Alle Daten löschen?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Alle Daten löschen", role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text("Diese Aktion löscht alle Geräte, Kunden, Ausleihen und Stammdaten unwiderruflich.")
            }
        }
    }

    // MARK: - Actions

    private func createBackup() {
        isCreatingBackup = true

        // Create backup data
        let backup = BackupData(
            version: Constants.App.version,
            createdAt: Date(),
            equipment: equipment.map { $0.toBackupFormat() },
            customers: customers.map { $0.toBackupFormat() },
            rentals: rentals.map { $0.toBackupFormat() },
            categories: categories.map { $0.toBackupFormat() },
            conditions: conditions.map { $0.toBackupFormat() },
            locations: locations.map { $0.toBackupFormat() }
        )

        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(backup)
            let filename = "MediaTechManager_Backup_\(Date().formatted(.dateTime.year().month().day())).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

            try data.write(to: tempURL)
            backupURL = tempURL

            isCreatingBackup = false
            showShareSheet = true

        } catch {
            Logger.error(error, message: "Failed to create backup")
            toastManager.error("Backup fehlgeschlagen")
            isCreatingBackup = false
        }
    }

    private func deleteAllData() {
        // Delete all entities
        for item in equipment { modelContext.delete(item) }
        for item in customers { modelContext.delete(item) }
        for item in rentals { modelContext.delete(item) }
        for item in categories { modelContext.delete(item) }
        for item in conditions { modelContext.delete(item) }
        for item in locations { modelContext.delete(item) }

        do {
            try modelContext.save()
            toastManager.success("Alle Daten gelöscht")
        } catch {
            Logger.error(error, message: "Failed to delete all data")
            toastManager.error("Löschen fehlgeschlagen")
        }
    }
}

// MARK: - Stat Row

struct StatRow: View {
    let title: String
    let count: Int
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            Text(title)

            Spacer()

            Text("\(count)")
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Backup Data

struct BackupData: Codable {
    let version: String
    let createdAt: Date
    let equipment: [[String: String]]
    let customers: [[String: String]]
    let rentals: [[String: String]]
    let categories: [[String: String]]
    let conditions: [[String: String]]
    let locations: [[String: String]]
}

// MARK: - Backup Format Extensions

extension Equipment {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "name": name,
            "manufacturer": manufacturer,
            "model": model,
            "inventoryNumber": inventoryNumber,
            "serialNumber": serialNumber,
            "isAvailable": String(isAvailable)
        ]
    }
}

extension Customer {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "customerType": customerType.rawValue
        ]
    }
}

extension Rental {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "rentalNumber": rentalNumber,
            "status": status.rawValue,
            "totalPrice": String(totalPrice)
        ]
    }
}

extension Category {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "name": name,
            "iconName": iconName,
            "colorHex": colorHex
        ]
    }
}

extension Condition {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "name": name,
            "iconName": iconName,
            "colorHex": colorHex
        ]
    }
}

extension Location {
    func toBackupFormat() -> [String: String] {
        [
            "id": id.uuidString,
            "name": name,
            "iconName": iconName,
            "colorHex": colorHex
        ]
    }
}

// MARK: - Preview

#Preview {
    BackupRestoreView()
        .modelContainer(for: [Equipment.self, Customer.self, Rental.self, Category.self, Condition.self, Location.self])
        .environmentObject(ToastManager())
}
