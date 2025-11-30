//
//  DashboardView.swift
//  MediaTechManager
//
//  Dashboard mit Übersicht
//

import SwiftUI
import SwiftData

struct DashboardView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager
    @EnvironmentObject private var appState: AppStateManager

    // MARK: - Queries

    @Query private var equipment: [Equipment]
    @Query private var rentals: [Rental]
    @Query private var customers: [Customer]

    // MARK: - State

    @State private var showNewEquipment = false
    @State private var showNewRental = false
    @State private var showScannerMenu = false
    @State private var showQuickScanner = false
    @State private var quickScanMode: QRScanMode = .single
    @State private var scannedEquipment: Equipment?
    @State private var showEquipmentDetail = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Quick Stats
                    statsSection

                    // Scanner Quick Access
                    scannerQuickAccessSection

                    // Quick Actions
                    quickActionsSection

                    // Überfällige Ausleihen
                    if !overdueRentals.isEmpty {
                        overdueSection
                    }

                    // Aktive Ausleihen
                    if !activeRentals.isEmpty {
                        activeRentalsSection
                    }
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            showNewEquipment = true
                        } label: {
                            Label("Neues Gerät", systemImage: "plus.circle")
                        }

                        Button {
                            showNewRental = true
                        } label: {
                            Label("Neue Ausleihe", systemImage: "arrow.right.circle")
                        }
                        
                        Divider()

                        Button {
                            showScannerMenu = true
                        } label: {
                            Label("Scanner öffnen", systemImage: "qrcode.viewfinder")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showNewEquipment) {
                EquipmentEditView(equipment: nil)
            }
            .sheet(isPresented: $showNewRental) {
                NewRentalView()
            }
            .sheet(isPresented: $showScannerMenu) {
                ScannerMenuView()
            }
            .fullScreenCover(isPresented: $showQuickScanner) {
                QRCodeScannerView(mode: quickScanMode) { scannedCode in
                    handleQuickScan(scannedCode)
                } onBatchComplete: { results in
                    handleBatchScanComplete(results)
                }
            }
            .sheet(isPresented: $showEquipmentDetail) {
                if let equipment = scannedEquipment {
                    NavigationStack {
                        EquipmentDetailView(equipment: equipment)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Schließen") {
                                        showEquipmentDetail = false
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Scanner Quick Access Section
    
    private var scannerQuickAccessSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: "qrcode.viewfinder")
                    .foregroundStyle(Color.brandPrimary)
                Text("Schnellzugriff Scanner")
                    .font(.titleMedium)
            }
            
            HStack(spacing: Spacing.sm) {
                ScannerQuickButton(
                    title: "Ausleihe",
                    icon: "arrow.up.forward.circle.fill",
                    color: .orange
                ) {
                    quickScanMode = .checkout
                    showQuickScanner = true
                }
                
                ScannerQuickButton(
                    title: "Rückgabe",
                    icon: "arrow.down.backward.circle.fill",
                    color: .green
                ) {
                    quickScanMode = .checkin
                    showQuickScanner = true
                }
                
                ScannerQuickButton(
                    title: "Suchen",
                    icon: "magnifyingglass",
                    color: .purple
                ) {
                    quickScanMode = .single
                    showQuickScanner = true
                }
                
                ScannerQuickButton(
                    title: "Mehr",
                    icon: "ellipsis.circle.fill",
                    color: .gray
                ) {
                    showScannerMenu = true
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }
    
    // MARK: - Quick Scan Handler
    
    private func handleQuickScan(_ code: String) {
        guard let content = QRCodeService.parseQRContent(code) else {
            toastManager.error("Ungültiger QR-Code")
            return
        }
        
        switch content {
        case .equipment(let inventoryNumber):
            if let equipment = findEquipment(byInventoryNumber: inventoryNumber) {
                scannedEquipment = equipment
                showEquipmentDetail = true
            } else {
                toastManager.warning("Gerät nicht gefunden")
            }
        case .equipmentById(let id):
            if let equipment = findEquipment(byId: id) {
                scannedEquipment = equipment
                showEquipmentDetail = true
            } else {
                toastManager.warning("Gerät nicht gefunden")
            }
        case .rental(let rentalId):
            toastManager.info("Ausleihe: \(rentalId.prefix(8))...")
        }
    }
    
    private func handleBatchScanComplete(_ results: [QRScanResult]) {
        let validCount = results.filter { $0.isValid }.count
        if validCount > 0 {
            toastManager.success("\(validCount) Gerät(e) verarbeitet")
        }
    }
    
    private func findEquipment(byInventoryNumber inventoryNumber: String) -> Equipment? {
        equipment.first { $0.inventoryNumber == inventoryNumber }
    }
    
    private func findEquipment(byId id: String) -> Equipment? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return equipment.first { $0.id == uuid }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: Spacing.md) {
            StatCard(
                title: "Geräte gesamt",
                value: "\(equipment.count)",
                icon: "shippingbox.fill",
                color: Color(hex: "007AFF")
            )

            StatCard(
                title: "Verfügbar",
                value: "\(availableCount)",
                icon: "checkmark.circle.fill",
                color: Color(hex: "34C759")
            )

            StatCard(
                title: "Ausgeliehen",
                value: "\(rentedCount)",
                icon: "arrow.right.circle.fill",
                color: Color(hex: "FF9500")
            )

            StatCard(
                title: "Überfällig",
                value: "\(overdueRentals.count)",
                icon: "exclamationmark.triangle.fill",
                color: overdueRentals.isEmpty ? .gray : Color(hex: "FF3B30")
            )
        }
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Schnellaktionen")
                .font(.titleMedium)
                .foregroundStyle(.primary)

            HStack(spacing: Spacing.md) {
                QuickActionButton(
                    title: "Scannen",
                    icon: "qrcode.viewfinder",
                    color: Color(hex: "007AFF")
                ) {
                    showScannerMenu = true
                }

                QuickActionButton(
                    title: "Ausleihen",
                    icon: "arrow.right.circle",
                    color: Color(hex: "34C759")
                ) {
                    showNewRental = true
                }

                QuickActionButton(
                    title: "Hinzufügen",
                    icon: "plus.circle",
                    color: Color(hex: "5856D6")
                ) {
                    showNewEquipment = true
                }
            }
        }
    }

    // MARK: - Overdue Section

    private var overdueSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color(hex: "FF3B30"))
                Text("Überfällige Ausleihen")
                    .font(.titleMedium)
                Spacer()
                Text("\(overdueRentals.count)")
                    .font(.titleSmall)
                    .foregroundStyle(Color(hex: "FF3B30"))
            }

            ForEach(overdueRentals.prefix(3)) { rental in
                RentalRowCompact(rental: rental)
            }
        }
        .padding(Spacing.cardPadding)
        .background(Color(hex: "FF3B30").opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }

    // MARK: - Active Rentals Section

    private var activeRentalsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Aktive Ausleihen")
                    .font(.titleMedium)
                Spacer()
                Text("\(activeRentals.count)")
                    .font(.titleSmall)
                    .foregroundStyle(.secondary)
            }

            ForEach(activeRentals.prefix(5)) { rental in
                RentalRowCompact(rental: rental)
            }
        }
    }

    // MARK: - Computed Properties

    private var availableCount: Int {
        equipment.filter { $0.isAvailable }.count
    }

    private var rentedCount: Int {
        equipment.filter { !$0.isAvailable }.count
    }

    private var overdueRentals: [Rental] {
        rentals.filter { $0.status == .overdue }
    }

    private var activeRentals: [Rental] {
        rentals.filter { $0.status == .active }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(color)

                Text(title)
                    .font(.labelMedium)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Scanner Quick Button

struct ScannerQuickButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xxs) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(color)
                }

                Text(title)
                    .font(.labelSmall)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Rental Row Compact

struct RentalRowCompact: View {
    let rental: Rental

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(rental.customer?.fullName ?? "Unbekannt")
                    .font(.titleSmall)
                    .foregroundStyle(.primary)

                Text(rental.dateRangeString)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            StatusBadge(status: rental.status)
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
        .modelContainer(for: [Equipment.self, Rental.self, Customer.self])
        .environmentObject(ToastManager())
}
