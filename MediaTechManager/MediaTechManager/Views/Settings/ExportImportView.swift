//
//  ExportImportView.swift
//  MediaTechManager
//
//  Daten-Export und -Import
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ExportImportView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query private var equipment: [Equipment]
    @Query private var customers: [Customer]
    @Query private var rentals: [Rental]

    // MARK: - State

    @State private var selectedDataType: DataType = .equipment
    @State private var selectedFormat: ExportService.ExportFormat = .csv
    @State private var isExporting = false
    @State private var showShareSheet = false
    @State private var exportURL: URL?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                // Export Section
                Section {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Daten exportieren")
                            .font(.titleMedium)

                        Text("Exportieren Sie Ihre Daten als CSV oder JSON Datei.")
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xs)
                }

                Section("Datentyp auswählen") {
                    Picker("Daten", selection: $selectedDataType) {
                        ForEach(DataType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.displayName)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Format") {
                    Picker("Format", selection: $selectedFormat) {
                        ForEach(ExportService.ExportFormat.allCases, id: \.self) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    HStack {
                        Text("Anzahl Datensätze")
                        Spacer()
                        Text("\(dataCount)")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button {
                        exportData()
                    } label: {
                        HStack {
                            Spacer()
                            if isExporting {
                                ProgressView()
                                    .padding(.trailing, Spacing.sm)
                            }
                            Image(systemName: "square.and.arrow.up")
                            Text("Exportieren")
                            Spacer()
                        }
                    }
                    .disabled(isExporting || dataCount == 0)
                }

                // Info Section
                Section {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("CSV", systemImage: "tablecells")
                            .font(.labelMedium)

                        Text("Kompatibel mit Excel, Numbers und anderen Tabellenkalkulationen.")
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xxs)

                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("JSON", systemImage: "doc.text")
                            .font(.labelMedium)

                        Text("Strukturiertes Format für technische Weiterverarbeitung.")
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xxs)
                } header: {
                    Text("Formate")
                }
            }
            .navigationTitle("Export / Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = exportURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var dataCount: Int {
        switch selectedDataType {
        case .equipment:
            return equipment.count
        case .customers:
            return customers.count
        case .rentals:
            return rentals.count
        case .all:
            return equipment.count + customers.count + rentals.count
        }
    }

    // MARK: - Actions

    private func exportData() {
        isExporting = true

        let data: Data?
        let filename: String

        switch (selectedDataType, selectedFormat) {
        case (.equipment, .csv):
            data = ExportService.exportEquipmentAsCSV(equipment)
            filename = ExportService.generateFilename(prefix: "geraete", format: .csv)

        case (.equipment, .json):
            data = ExportService.exportEquipmentAsJSON(equipment)
            filename = ExportService.generateFilename(prefix: "geraete", format: .json)

        case (.customers, .csv):
            data = ExportService.exportCustomersAsCSV(customers)
            filename = ExportService.generateFilename(prefix: "kunden", format: .csv)

        case (.customers, .json):
            data = ExportService.exportCustomersAsJSON(customers)
            filename = ExportService.generateFilename(prefix: "kunden", format: .json)

        case (.rentals, .csv):
            data = ExportService.exportRentalsAsCSV(rentals)
            filename = ExportService.generateFilename(prefix: "ausleihen", format: .csv)

        case (.rentals, .json):
            data = ExportService.exportRentalsAsJSON(rentals)
            filename = ExportService.generateFilename(prefix: "ausleihen", format: .json)

        case (.all, _):
            // For "all", always use JSON
            data = ExportService.createFullBackup(
                equipment: equipment,
                customers: customers,
                rentals: rentals,
                categories: [],
                conditions: [],
                locations: []
            )
            filename = ExportService.generateFilename(prefix: "backup", format: .json)
        }

        isExporting = false

        guard let exportData = data else {
            toastManager.error("Export fehlgeschlagen")
            return
        }

        // Save to temp file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        do {
            try exportData.write(to: tempURL)
            exportURL = tempURL
            showShareSheet = true
        } catch {
            Logger.error(error, message: "Failed to write export file")
            toastManager.error("Export fehlgeschlagen")
        }
    }
}

// MARK: - Data Type

enum DataType: String, CaseIterable {
    case equipment
    case customers
    case rentals
    case all

    var displayName: String {
        switch self {
        case .equipment:
            return "Geräte"
        case .customers:
            return "Kunden"
        case .rentals:
            return "Ausleihen"
        case .all:
            return "Alle Daten"
        }
    }

    var icon: String {
        switch self {
        case .equipment:
            return "shippingbox"
        case .customers:
            return "person.2"
        case .rentals:
            return "arrow.left.arrow.right"
        case .all:
            return "tray.full"
        }
    }
}

// MARK: - Preview

#Preview {
    ExportImportView()
        .modelContainer(for: [Equipment.self, Customer.self, Rental.self])
        .environmentObject(ToastManager())
}
