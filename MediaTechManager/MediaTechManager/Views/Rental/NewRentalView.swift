//
//  NewRentalView.swift
//  MediaTechManager
//
//  Neue Ausleihe erstellen
//

import SwiftUI
import SwiftData

struct NewRentalView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Customer.lastName) private var customers: [Customer]
    @Query(filter: #Predicate<Equipment> { $0.isAvailable && $0.isActive })
    private var availableEquipment: [Equipment]

    // MARK: - State

    @State private var selectedCustomer: Customer?
    @State private var selectedEquipment: Set<Equipment> = []
    @State private var startDate = Date()
    @State private var endDate = Date().addingDays(1)
    @State private var purpose = ""
    @State private var eventLocation = ""
    @State private var notes = ""
    @State private var depositAmount: Double = 0

    @State private var isSaving = false
    @State private var showCustomerPicker = false
    @State private var showEquipmentPicker = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                // Kunde
                Section("Kunde") {
                    if let customer = selectedCustomer {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(customer.fullName)
                                    .font(.titleMedium)
                                if let company = customer.company {
                                    Text(company)
                                        .font(.bodySmall)
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

                // Geräte
                Section("Geräte (\(selectedEquipment.count))") {
                    if !selectedEquipment.isEmpty {
                        ForEach(Array(selectedEquipment)) { equipment in
                            HStack {
                                Text(equipment.displayName)
                                    .font(.bodyMedium)

                                Spacer()

                                if let rate = equipment.dailyRate {
                                    Text("\(rate, format: .currency(code: "EUR"))/Tag")
                                        .font(.labelSmall)
                                        .foregroundStyle(.secondary)
                                }

                                Button {
                                    selectedEquipment.remove(equipment)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    Button {
                        showEquipmentPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Gerät hinzufügen")
                        }
                    }
                }

                // Zeitraum
                Section("Zeitraum") {
                    DatePicker("Von", selection: $startDate, displayedComponents: .date)
                    DatePicker("Bis", selection: $endDate, in: startDate..., displayedComponents: .date)

                    HStack {
                        Text("Dauer")
                        Spacer()
                        Text("\(numberOfDays) Tag(e)")
                            .foregroundStyle(.secondary)
                    }
                }

                // Details
                Section("Details") {
                    TextField("Verwendungszweck", text: $purpose)
                    TextField("Veranstaltungsort", text: $eventLocation)
                }

                // Finanzen
                Section("Finanzen") {
                    HStack {
                        Text("Gesamtpreis")
                        Spacer()
                        Text(calculatedTotal, format: .currency(code: "EUR"))
                            .font(.titleMedium)
                    }

                    HStack {
                        Text("Kaution")
                        Spacer()
                        TextField("€", value: $depositAmount, format: .currency(code: "EUR"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                // Notizen
                Section("Notizen") {
                    TextField("Interne Notizen", text: $notes, axis: .vertical)
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
                    .disabled(!canSave || isSaving)
                }
            }
            .sheet(isPresented: $showCustomerPicker) {
                CustomerPickerView(selectedCustomer: $selectedCustomer)
            }
            .sheet(isPresented: $showEquipmentPicker) {
                EquipmentPickerView(
                    availableEquipment: availableEquipment,
                    selectedEquipment: $selectedEquipment
                )
            }
        }
    }

    // MARK: - Computed Properties

    private var numberOfDays: Int {
        max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1)
    }

    private var calculatedTotal: Double {
        selectedEquipment.reduce(0) { total, equipment in
            total + (equipment.dailyRate ?? 0) * Double(numberOfDays)
        }
    }

    private var canSave: Bool {
        selectedCustomer != nil && !selectedEquipment.isEmpty
    }

    // MARK: - Actions

    private func createRental() {
        guard let customer = selectedCustomer else { return }

        isSaving = true

        let rental = Rental(
            rentalNumber: appState.nextRentalNumber(),
            plannedStartDate: startDate,
            plannedEndDate: endDate,
            status: .reserved,
            customer: customer,
            totalPrice: calculatedTotal,
            depositAmount: depositAmount,
            purpose: purpose,
            eventLocation: eventLocation,
            notes: notes
        )

        // Create rental items
        for equipment in selectedEquipment {
            let item = RentalItem(
                rental: rental,
                equipment: equipment,
                quantity: 1,
                dailyRate: equipment.dailyRate ?? 0,
                days: numberOfDays
            )
            rental.items.append(item)
            equipment.isAvailable = false
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

// MARK: - Customer Picker

struct CustomerPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Customer.lastName) private var customers: [Customer]
    @Binding var selectedCustomer: Customer?
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCustomers) { customer in
                    Button {
                        selectedCustomer = customer
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(customer.fullName)
                                    .foregroundStyle(.primary)
                                if let company = customer.company {
                                    Text(company)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if selectedCustomer?.id == customer.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color(hex: "007AFF"))
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Kunde suchen...")
            .navigationTitle("Kunde auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private var filteredCustomers: [Customer] {
        guard !searchText.isEmpty else { return customers }
        return customers.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
    }
}

// MARK: - Equipment Picker

struct EquipmentPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let availableEquipment: [Equipment]
    @Binding var selectedEquipment: Set<Equipment>
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredEquipment) { equipment in
                    Button {
                        if selectedEquipment.contains(equipment) {
                            selectedEquipment.remove(equipment)
                        } else {
                            selectedEquipment.insert(equipment)
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(equipment.displayName)
                                    .foregroundStyle(.primary)
                                if let rate = equipment.dailyRate {
                                    Text("\(rate, format: .currency(code: "EUR"))/Tag")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if selectedEquipment.contains(equipment) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color(hex: "007AFF"))
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Gerät suchen...")
            .navigationTitle("Geräte auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") { dismiss() }
                }
            }
        }
    }

    private var filteredEquipment: [Equipment] {
        guard !searchText.isEmpty else { return availableEquipment }
        return availableEquipment.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.manufacturer.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Preview

#Preview {
    NewRentalView()
        .modelContainer(for: [Rental.self, Customer.self, Equipment.self])
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
