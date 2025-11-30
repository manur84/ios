//
//  ScannerMenuView.swift
//  MediaTechManager
//
//  Zentrales Scanner-Menü für schnellen Zugriff auf alle Scan-Funktionen
//

import SwiftUI
import SwiftData

struct ScannerMenuView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager
    
    // MARK: - State
    
    @State private var selectedMode: QRScanMode?
    @State private var showScanner = false
    @State private var scannedEquipment: [Equipment] = []
    @State private var showRentalCreation = false
    @State private var showEquipmentDetail = false
    @State private var selectedEquipment: Equipment?
    @State private var showInventoryResult = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    headerSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Scan History (last scans)
                    if !scannedEquipment.isEmpty {
                        recentScansSection
                    }
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
            .fullScreenCover(isPresented: $showScanner) {
                if let mode = selectedMode {
                    QRCodeScannerView(
                        mode: mode,
                        onScan: handleScan,
                        onBatchComplete: handleBatchComplete
                    )
                    .environmentObject(toastManager)
                }
            }
            .sheet(isPresented: $showRentalCreation) {
                NewRentalFromScanView(equipment: scannedEquipment)
            }
            .sheet(isPresented: $showEquipmentDetail) {
                if let equipment = selectedEquipment {
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
            .sheet(isPresented: $showInventoryResult) {
                InventoryResultView(
                    scannedEquipment: scannedEquipment,
                    onDismiss: {
                        showInventoryResult = false
                        scannedEquipment.removeAll()
                    }
                )
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.brandPrimary)
            }
            
            Text("Wählen Sie eine Scan-Aktion")
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, Spacing.md)
    }
    
    // MARK: - Quick Actions Section
    
    private var quickActionsSection: some View {
        VStack(spacing: Spacing.sm) {
            // Row 1: Checkout & Checkin
            HStack(spacing: Spacing.sm) {
                ScanActionCard(
                    title: "Ausleihe",
                    subtitle: "Geräte verleihen",
                    icon: "arrow.up.forward.circle.fill",
                    color: .orange
                ) {
                    startScan(.checkout)
                }
                
                ScanActionCard(
                    title: "Rückgabe",
                    subtitle: "Geräte zurückgeben",
                    icon: "arrow.down.backward.circle.fill",
                    color: .green
                ) {
                    startScan(.checkin)
                }
            }
            
            // Row 2: Inventory & Single
            HStack(spacing: Spacing.sm) {
                ScanActionCard(
                    title: "Inventur",
                    subtitle: "Bestand prüfen",
                    icon: "checklist",
                    color: .cyan
                ) {
                    startScan(.inventory)
                }
                
                ScanActionCard(
                    title: "Gerät finden",
                    subtitle: "Details anzeigen",
                    icon: "magnifyingglass",
                    color: .purple
                ) {
                    startScan(.single)
                }
            }
            
            // Batch Scan Button
            Button {
                startScan(.batch)
            } label: {
                HStack {
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mehrfachscan")
                            .font(.titleSmall)
                        Text("Mehrere Geräte auf einmal scannen")
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding(Spacing.md)
                .background(Color.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Recent Scans Section
    
    private var recentScansSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Zuletzt gescannt")
                    .font(.titleMedium)
                
                Spacer()
                
                Button("Löschen") {
                    withAnimation {
                        scannedEquipment.removeAll()
                    }
                }
                .font(.labelMedium)
                .foregroundStyle(.secondary)
            }
            
            ForEach(scannedEquipment.prefix(5)) { equipment in
                RecentScanRow(equipment: equipment) {
                    selectedEquipment = equipment
                    showEquipmentDetail = true
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }
    
    // MARK: - Actions
    
    private func startScan(_ mode: QRScanMode) {
        selectedMode = mode
        showScanner = true
        HapticManager.medium()
    }
    
    private func handleScan(_ code: String) {
        // Find equipment from code
        if let content = QRCodeService.parseQRContent(code) {
            switch content {
            case .equipment(let inventoryNumber):
                if let equipment = findEquipment(byInventoryNumber: inventoryNumber) {
                    if !scannedEquipment.contains(where: { $0.id == equipment.id }) {
                        scannedEquipment.append(equipment)
                    }
                }
            case .equipmentById(let id):
                if let equipment = findEquipment(byId: id) {
                    if !scannedEquipment.contains(where: { $0.id == equipment.id }) {
                        scannedEquipment.append(equipment)
                    }
                }
            case .rental:
                // Handle rental code
                break
            }
        }
    }
    
    private func handleBatchComplete(_ results: [QRScanResult]) {
        showScanner = false
        
        // Collect all valid equipment
        let validEquipment = results.compactMap { $0.equipment }
        scannedEquipment = validEquipment
        
        guard !validEquipment.isEmpty else {
            toastManager.warning("Keine gültigen Geräte gescannt")
            return
        }
        
        // Handle based on mode
        guard let mode = selectedMode else { return }
        
        switch mode {
        case .checkout:
            showRentalCreation = true
        case .checkin:
            returnEquipment(validEquipment)
        case .inventory:
            showInventoryResult = true
        case .batch:
            toastManager.success("\(validEquipment.count) Geräte gescannt")
        case .single:
            if let first = validEquipment.first {
                selectedEquipment = first
                showEquipmentDetail = true
            }
        }
    }
    
    private func findEquipment(byInventoryNumber inventoryNumber: String) -> Equipment? {
        let descriptor = FetchDescriptor<Equipment>(
            predicate: #Predicate { $0.inventoryNumber == inventoryNumber }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    private func findEquipment(byId id: String) -> Equipment? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        let descriptor = FetchDescriptor<Equipment>(
            predicate: #Predicate { $0.id == uuid }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    private func returnEquipment(_ equipment: [Equipment]) {
        for item in equipment {
            item.isAvailable = true
            item.touch()
        }
        
        do {
            try modelContext.save()
            toastManager.success("\(equipment.count) Gerät(e) zurückgegeben")
        } catch {
            Logger.error(error, message: "Failed to return equipment")
            toastManager.error("Fehler bei der Rückgabe")
        }
    }
}

// MARK: - Scan Action Card

struct ScanActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                }
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.titleSmall)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.lg)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Recent Scan Row

struct RecentScanRow: View {
    let equipment: Equipment
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.sm) {
                // Thumbnail
                if let imageData = equipment.primaryImage,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.backgroundTertiary)
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "shippingbox.fill")
                                .foregroundStyle(.secondary)
                        }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(equipment.displayName)
                        .font(.bodyMedium)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(equipment.inventoryNumber)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Availability indicator
                Circle()
                    .fill(equipment.isAvailable ? Color.green : Color.orange)
                    .frame(width: 8, height: 8)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, Spacing.xs)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - New Rental From Scan View

struct NewRentalFromScanView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager
    
    let equipment: [Equipment]
    
    @Query(sort: \Customer.lastName) private var customers: [Customer]
    
    @State private var selectedCustomer: Customer?
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400)
    @State private var notes = ""
    @State private var isSaving = false
    @State private var showCustomerPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Equipment Section
                Section("Ausgewählte Geräte (\(equipment.count))") {
                    ForEach(equipment) { item in
                        HStack {
                            Text(item.displayName)
                                .font(.bodyMedium)
                            
                            Spacer()
                            
                            if let rate = item.dailyRate {
                                Text(rate, format: .currency(code: "EUR"))
                                    .font(.labelSmall)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // Customer Section
                Section("Kunde") {
                    if let customer = selectedCustomer {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(customer.fullName)
                                    .font(.bodyMedium)
                                if let company = customer.company {
                                    Text(company)
                                        .font(.labelSmall)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button("Ändern") {
                                showCustomerPicker = true
                            }
                        }
                    } else {
                        Button {
                            showCustomerPicker = true
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Kunde auswählen")
                            }
                        }
                    }
                }
                
                // Date Section
                Section("Zeitraum") {
                    DatePicker("Von", selection: $startDate, displayedComponents: .date)
                    DatePicker("Bis", selection: $endDate, in: startDate..., displayedComponents: .date)
                }
                
                // Summary
                Section("Zusammenfassung") {
                    HStack {
                        Text("Gesamtpreis")
                        Spacer()
                        Text(calculatedTotal, format: .currency(code: "EUR"))
                            .fontWeight(.semibold)
                    }
                }
                
                // Notes
                Section("Notizen") {
                    TextField("Optionale Notizen", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Neue Ausleihe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        createRental()
                    }
                    .disabled(selectedCustomer == nil || isSaving)
                }
            }
            .sheet(isPresented: $showCustomerPicker) {
                CustomerPickerView(selectedCustomer: $selectedCustomer)
            }
        }
    }
    
    private var numberOfDays: Int {
        max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1)
    }
    
    private var calculatedTotal: Double {
        equipment.reduce(0) { $0 + ($1.dailyRate ?? 0) } * Double(numberOfDays)
    }
    
    private func createRental() {
        guard let customer = selectedCustomer else { return }
        
        isSaving = true
        
        let rental = Rental(
            rentalNumber: appState.nextRentalNumber(),
            plannedStartDate: startDate,
            plannedEndDate: endDate,
            status: .active,
            customer: customer,
            totalPrice: calculatedTotal,
            notes: notes
        )
        
        rental.actualStartDate = Date()
        
        for item in equipment {
            let rentalItem = RentalItem(
                rental: rental,
                equipment: item,
                quantity: 1,
                dailyRate: item.dailyRate ?? 0,
                days: numberOfDays
            )
            rental.items.append(rentalItem)
            item.isAvailable = false
        }
        
        modelContext.insert(rental)
        
        do {
            try modelContext.save()
            toastManager.success("Ausleihe erstellt")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to create rental")
            toastManager.error("Fehler beim Erstellen")
            isSaving = false
        }
    }
}

// MARK: - Inventory Result View

struct InventoryResultView: View {
    let scannedEquipment: [Equipment]
    let onDismiss: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Query private var allEquipment: [Equipment]
    
    var body: some View {
        NavigationStack {
            List {
                // Summary
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(scannedEquipment.count)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.green)
                            Text("Gescannt")
                                .font(.labelSmall)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("\(allEquipment.count)")
                                .font(.system(size: 36, weight: .bold))
                            Text("Gesamt")
                                .font(.labelSmall)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(missingEquipment.count)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(missingEquipment.isEmpty ? .green : .orange)
                            Text("Nicht erfasst")
                                .font(.labelSmall)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, Spacing.sm)
                }
                
                // Scanned Equipment
                Section("Erfasste Geräte") {
                    ForEach(scannedEquipment) { equipment in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            
                            VStack(alignment: .leading) {
                                Text(equipment.displayName)
                                    .font(.bodyMedium)
                                Text(equipment.inventoryNumber)
                                    .font(.labelSmall)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                
                // Missing Equipment
                if !missingEquipment.isEmpty {
                    Section("Nicht erfasst") {
                        ForEach(missingEquipment) { equipment in
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.orange)
                                
                                VStack(alignment: .leading) {
                                    Text(equipment.displayName)
                                        .font(.bodyMedium)
                                    Text(equipment.inventoryNumber)
                                        .font(.labelSmall)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                if !equipment.isAvailable {
                                    Text("Verliehen")
                                        .font(.labelSmall)
                                        .foregroundStyle(.orange)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Inventur-Ergebnis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        onDismiss()
                    }
                }
            }
        }
    }
    
    private var missingEquipment: [Equipment] {
        allEquipment.filter { equipment in
            !scannedEquipment.contains(where: { $0.id == equipment.id })
        }
    }
}

// MARK: - Preview

#Preview {
    ScannerMenuView()
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
