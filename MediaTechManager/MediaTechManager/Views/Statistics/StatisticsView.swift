//
//  StatisticsView.swift
//  MediaTechManager
//
//  Statistiken und Berichte
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext

    // MARK: - Queries

    @Query private var equipment: [Equipment]
    @Query private var customers: [Customer]
    @Query private var rentals: [Rental]
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    // MARK: - State

    @State private var selectedPeriod: StatisticsPeriod = .month
    @State private var showExportSheet = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Period Picker
                    periodPicker

                    // Overview Stats
                    overviewSection

                    // Revenue Chart
                    revenueChartSection

                    // Equipment by Category
                    categoryChartSection

                    // Rental Status Distribution
                    rentalStatusSection

                    // Top Equipment
                    topEquipmentSection

                    // Top Customers
                    topCustomersSection
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Statistiken")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showExportSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showExportSheet) {
                StatisticsExportView()
            }
        }
    }

    // MARK: - Period Picker

    private var periodPicker: some View {
        Picker("Zeitraum", selection: $selectedPeriod) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Text(period.displayName).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Overview Section

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Übersicht")
                .font(.titleMedium)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.sm) {
                StatCard(
                    title: "Geräte",
                    value: "\(equipment.count)",
                    icon: "shippingbox.fill",
                    color: .blue
                )

                StatCard(
                    title: "Verfügbar",
                    value: "\(equipment.filter { $0.isAvailable }.count)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )

                StatCard(
                    title: "Ausleihen",
                    value: "\(filteredRentals.count)",
                    icon: "arrow.left.arrow.right",
                    color: .purple
                )

                StatCard(
                    title: "Umsatz",
                    value: totalRevenue.formatted(.currency(code: "EUR")),
                    icon: "eurosign.circle.fill",
                    color: .orange
                )
            }
        }
    }

    // MARK: - Revenue Chart Section

    private var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Umsatz")
                .font(.titleMedium)

            Chart(revenueData) { dataPoint in
                BarMark(
                    x: .value("Monat", dataPoint.label),
                    y: .value("Umsatz", dataPoint.value)
                )
                .foregroundStyle(Color(hex: "007AFF").gradient)
                .cornerRadius(4)
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Double.self) {
                            Text("\(Int(intValue))€")
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Category Chart Section

    private var categoryChartSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Geräte nach Kategorie")
                .font(.titleMedium)

            if categoryData.isEmpty {
                Text("Keine Kategorien vorhanden")
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, Spacing.lg)
            } else {
                Chart(categoryData) { dataPoint in
                    SectorMark(
                        angle: .value("Anzahl", dataPoint.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .cornerRadius(4)
                    .foregroundStyle(by: .value("Kategorie", dataPoint.label))
                }
                .frame(height: 200)
            }

            // Legend
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.xs) {
                ForEach(categoryData) { dataPoint in
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(Color(hex: dataPoint.color))
                            .frame(width: 10, height: 10)

                        Text(dataPoint.label)
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(Int(dataPoint.value))")
                            .font(.labelSmall)
                    }
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Rental Status Section

    private var rentalStatusSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Ausleihen nach Status")
                .font(.titleMedium)

            ForEach(rentalStatusData) { dataPoint in
                HStack {
                    Circle()
                        .fill(Color(hex: dataPoint.color))
                        .frame(width: 10, height: 10)

                    Text(dataPoint.label)
                        .font(.bodyMedium)

                    Spacer()

                    Text("\(Int(dataPoint.value))")
                        .font(.bodyMedium)
                        .foregroundStyle(.secondary)

                    // Progress Bar
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: dataPoint.color).opacity(0.2))
                            .overlay(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: dataPoint.color))
                                    .frame(width: geometry.size.width * dataPoint.percentage)
                            }
                    }
                    .frame(width: 100, height: 8)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Top Equipment Section

    private var topEquipmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Meistverliehene Geräte")
                .font(.titleMedium)

            if topEquipment.isEmpty {
                Text("Noch keine Ausleihen")
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, Spacing.sm)
            } else {
                ForEach(Array(topEquipment.enumerated()), id: \.element.id) { index, item in
                    HStack {
                        Text("\(index + 1).")
                            .font(.labelMedium)
                            .foregroundStyle(.secondary)
                            .frame(width: 24)

                        Text(item.displayName)
                            .font(.bodyMedium)

                        Spacer()

                        Text("\(item.rentalCount)x")
                            .font(.labelMedium)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xxs)

                    if index < topEquipment.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Top Customers Section

    private var topCustomersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Top Kunden")
                .font(.titleMedium)

            if topCustomers.isEmpty {
                Text("Noch keine Kunden mit Ausleihen")
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, Spacing.sm)
            } else {
                ForEach(Array(topCustomers.enumerated()), id: \.element.id) { index, customer in
                    HStack {
                        Text("\(index + 1).")
                            .font(.labelMedium)
                            .foregroundStyle(.secondary)
                            .frame(width: 24)

                        Text(customer.fullName)
                            .font(.bodyMedium)

                        Spacer()

                        Text(customer.totalRevenue.formatted(.currency(code: "EUR")))
                            .font(.labelMedium)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Spacing.xxs)

                    if index < topCustomers.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Computed Properties

    private var filteredRentals: [Rental] {
        let startDate = selectedPeriod.startDate
        return rentals.filter { $0.createdAt >= startDate }
    }

    private var totalRevenue: Double {
        filteredRentals
            .filter { $0.status == .returned }
            .reduce(0) { $0 + $1.totalPrice }
    }

    private var revenueData: [ChartDataPoint] {
        let calendar = Calendar.current
        var data: [ChartDataPoint] = []

        let months = selectedPeriod == .year ? 12 : (selectedPeriod == .quarter ? 3 : 1)

        for i in 0..<months {
            guard let date = calendar.date(byAdding: .month, value: -i, to: Date()) else { continue }
            let monthName = date.formatted(.dateTime.month(.abbreviated))

            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!

            let monthRevenue = rentals
                .filter { $0.status == .returned && $0.createdAt >= monthStart && $0.createdAt < monthEnd }
                .reduce(0) { $0 + $1.totalPrice }

            data.append(ChartDataPoint(
                label: monthName,
                value: monthRevenue,
                color: "007AFF"
            ))
        }

        return data.reversed()
    }

    private var categoryData: [ChartDataPoint] {
        var data: [ChartDataPoint] = []

        for category in categories {
            let count = equipment.filter { $0.category?.id == category.id }.count
            if count > 0 {
                data.append(ChartDataPoint(
                    label: category.name,
                    value: Double(count),
                    color: category.colorHex
                ))
            }
        }

        // Add uncategorized
        let uncategorized = equipment.filter { $0.category == nil }.count
        if uncategorized > 0 {
            data.append(ChartDataPoint(
                label: "Ohne Kategorie",
                value: Double(uncategorized),
                color: "8E8E93"
            ))
        }

        return data
    }

    private var rentalStatusData: [ChartDataPoint] {
        let total = Double(filteredRentals.count)
        guard total > 0 else { return [] }

        return RentalStatus.allCases.compactMap { status in
            let count = filteredRentals.filter { $0.status == status }.count
            guard count > 0 else { return nil }
            return ChartDataPoint(
                label: status.displayName,
                value: Double(count),
                color: status.colorHex,
                percentage: Double(count) / total
            )
        }
    }

    private var topEquipment: [Equipment] {
        equipment
            .sorted { $0.rentalCount > $1.rentalCount }
            .prefix(5)
            .filter { $0.rentalCount > 0 }
            .map { $0 }
    }

    private var topCustomers: [Customer] {
        customers
            .sorted { $0.totalRevenue > $1.totalRevenue }
            .prefix(5)
            .filter { $0.totalRevenue > 0 }
            .map { $0 }
    }
}

// MARK: - Statistics Period

enum StatisticsPeriod: String, CaseIterable {
    case month = "Monat"
    case quarter = "Quartal"
    case year = "Jahr"

    var displayName: String { rawValue }

    var startDate: Date {
        let calendar = Calendar.current
        switch self {
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        case .quarter:
            return calendar.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        case .year:
            return calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        }
    }
}

// MARK: - Chart Data Point

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: String
    var percentage: Double = 0
}

// MARK: - Equipment Extension

extension Equipment {
    var rentalCount: Int {
        // Count how many times this equipment appears in rental items
        // This would need to be properly implemented with the relationship
        0 // Placeholder
    }
}

// MARK: - Statistics Export View

struct StatisticsExportView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    @Query private var equipment: [Equipment]
    @Query private var customers: [Customer]
    @Query private var rentals: [Rental]

    @State private var selectedExportType: ExportType = .equipment
    @State private var selectedFormat: ExportService.ExportFormat = .csv

    var body: some View {
        NavigationStack {
            Form {
                Section("Daten auswählen") {
                    Picker("Exportieren", selection: $selectedExportType) {
                        ForEach(ExportType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
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
                    Button("Exportieren") {
                        exportData()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func exportData() {
        let data: Data?

        switch (selectedExportType, selectedFormat) {
        case (.equipment, .csv):
            data = ExportService.exportEquipmentAsCSV(equipment)
        case (.equipment, .json):
            data = ExportService.exportEquipmentAsJSON(equipment)
        case (.customers, .csv):
            data = ExportService.exportCustomersAsCSV(customers)
        case (.customers, .json):
            data = ExportService.exportCustomersAsJSON(customers)
        case (.rentals, .csv):
            data = ExportService.exportRentalsAsCSV(rentals)
        case (.rentals, .json):
            data = ExportService.exportRentalsAsJSON(rentals)
        }

        guard let exportData = data else {
            toastManager.error("Export fehlgeschlagen")
            return
        }

        // Save and share
        let filename = ExportService.generateFilename(
            prefix: selectedExportType.rawValue,
            format: selectedFormat
        )

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        do {
            try exportData.write(to: tempURL)

            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }

            dismiss()
        } catch {
            Logger.error(error, message: "Export failed")
            toastManager.error("Export fehlgeschlagen")
        }
    }
}

// MARK: - Export Type

enum ExportType: String, CaseIterable {
    case equipment = "equipment"
    case customers = "customers"
    case rentals = "rentals"

    var displayName: String {
        switch self {
        case .equipment: return "Geräte"
        case .customers: return "Kunden"
        case .rentals: return "Ausleihen"
        }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView()
        .modelContainer(for: [Equipment.self, Customer.self, Rental.self, Category.self])
        .environmentObject(ToastManager())
}
