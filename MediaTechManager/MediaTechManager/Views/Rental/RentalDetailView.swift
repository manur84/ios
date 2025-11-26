//
//  RentalDetailView.swift
//  MediaTechManager
//
//  Ausleihe-Detailansicht
//

import SwiftUI

struct RentalDetailView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let rental: Rental

    // MARK: - State

    @State private var showReturnSheet = false
    @State private var showCancelConfirmation = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.sectionSpacing) {
                // Status Header
                statusHeader

                // Customer Info
                customerSection

                // Equipment
                equipmentSection

                // Timeline
                timelineSection

                // Financial
                financialSection

                // Notes
                if !rental.notes.isEmpty {
                    notesSection
                }

                // Actions
                actionsSection
            }
            .padding(Spacing.md)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Ausleihe #\(rental.rentalNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showReturnSheet) {
            ReturnRentalView(rental: rental)
        }
        .confirmationDialog(
            "Ausleihe stornieren?",
            isPresented: $showCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button("Stornieren", role: .destructive) {
                cancelRental()
            }
        } message: {
            Text("Diese Aktion kann nicht rückgängig gemacht werden.")
        }
    }

    // MARK: - Status Header

    private var statusHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Status")
                    .font(.labelMedium)
                    .foregroundStyle(.secondary)

                HStack(spacing: Spacing.xs) {
                    Image(systemName: rental.status.icon)
                    Text(rental.status.displayName)
                        .font(.titleMedium)
                }
                .foregroundStyle(Color(hex: rental.status.colorHex))
            }

            Spacer()

            if rental.isOverdue {
                VStack(alignment: .trailing, spacing: Spacing.xxs) {
                    Text("Überfällig seit")
                        .font(.labelMedium)
                        .foregroundStyle(.secondary)
                    Text("\(rental.daysOverdue) Tag(e)")
                        .font(.titleMedium)
                        .foregroundStyle(.red)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Customer Section

    private var customerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Kunde")
                .font(.titleMedium)

            if let customer = rental.customer {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(customer.fullName)
                            .font(.bodyLarge)

                        if let company = customer.company {
                            Text(company)
                                .font(.bodySmall)
                                .foregroundStyle(.secondary)
                        }

                        if let phone = customer.phone {
                            Button {
                                if let url = URL(string: "tel:\(phone)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Label(phone, systemImage: "phone")
                                    .font(.bodySmall)
                            }
                        }
                    }

                    Spacer()

                    NavigationLink {
                        CustomerDetailView(customer: customer)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("Kein Kunde zugewiesen")
                    .foregroundStyle(.secondary)
            }
        }
        .cardStyle()
    }

    // MARK: - Equipment Section

    private var equipmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Geräte (\(rental.items.count))")
                .font(.titleMedium)

            ForEach(rental.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(item.equipment?.displayName ?? "Unbekannt")
                            .font(.bodyMedium)

                        Text("\(item.quantity)x · \(item.days) Tag(e)")
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(item.totalPrice, format: .currency(code: "EUR"))
                        .font(.bodyMedium)
                }
                .padding(.vertical, Spacing.xxs)

                if item != rental.items.last {
                    Divider()
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Timeline Section

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Zeitraum")
                .font(.titleMedium)

            VStack(spacing: Spacing.xs) {
                DetailRow(
                    label: "Geplanter Start",
                    value: rental.plannedStartDate.formatted(date: .abbreviated, time: .omitted)
                )

                DetailRow(
                    label: "Geplantes Ende",
                    value: rental.plannedEndDate.formatted(date: .abbreviated, time: .omitted)
                )

                if let actualStart = rental.actualStartDate {
                    DetailRow(
                        label: "Tatsächlicher Start",
                        value: actualStart.formatted(date: .abbreviated, time: .omitted)
                    )
                }

                if let actualEnd = rental.actualEndDate {
                    DetailRow(
                        label: "Tatsächliches Ende",
                        value: actualEnd.formatted(date: .abbreviated, time: .omitted)
                    )
                }

                DetailRow(
                    label: "Dauer",
                    value: "\(rental.numberOfDays) Tag(e)"
                )
            }
        }
        .cardStyle()
    }

    // MARK: - Financial Section

    private var financialSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Finanzen")
                .font(.titleMedium)

            VStack(spacing: Spacing.xs) {
                DetailRow(
                    label: "Gesamtpreis",
                    value: rental.totalPrice.formatted(.currency(code: "EUR"))
                )

                if rental.depositAmount > 0 {
                    DetailRow(
                        label: "Kaution",
                        value: rental.depositAmount.formatted(.currency(code: "EUR"))
                    )

                    DetailRow(
                        label: "Kaution erhalten",
                        value: rental.depositReceived ? "Ja" : "Nein"
                    )

                    if rental.depositReceived && !rental.depositReturned {
                        DetailRow(
                            label: "Kaution zurückgegeben",
                            value: "Nein"
                        )
                    }
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Notes Section

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Notizen")
                .font(.titleMedium)

            Text(rental.notes)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(spacing: Spacing.sm) {
            switch rental.status {
            case .reserved:
                PrimaryButton("Ausleihe starten", icon: "play.fill") {
                    startRental()
                }

                SecondaryButton("Stornieren", icon: "xmark") {
                    showCancelConfirmation = true
                }

            case .active, .overdue:
                PrimaryButton("Rückgabe", icon: "arrow.uturn.left") {
                    showReturnSheet = true
                }

            case .returned, .cancelled:
                EmptyView()
            }
        }
    }

    // MARK: - Actions

    private func startRental() {
        rental.status = .active
        rental.actualStartDate = Date()

        do {
            try modelContext.save()
            toastManager.success("Ausleihe gestartet")
        } catch {
            Logger.error(error, message: "Failed to start rental")
            toastManager.error("Fehler beim Starten")
        }
    }

    private func cancelRental() {
        rental.status = .cancelled

        // Mark equipment as available again
        for item in rental.items {
            item.equipment?.isAvailable = true
        }

        do {
            try modelContext.save()
            toastManager.success("Ausleihe storniert")
        } catch {
            Logger.error(error, message: "Failed to cancel rental")
            toastManager.error("Fehler beim Stornieren")
        }
    }
}

// MARK: - Return Rental View

struct ReturnRentalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    let rental: Rental

    @State private var returnNotes = ""
    @State private var returnDeposit = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Rückgabe-Notizen") {
                    TextField("Notizen zur Rückgabe", text: $returnNotes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if rental.depositAmount > 0 && rental.depositReceived {
                    Section("Kaution") {
                        Toggle("Kaution zurückgeben", isOn: $returnDeposit)

                        Text("Kaution: \(rental.depositAmount.formatted(.currency(code: "EUR")))")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Geräte") {
                    ForEach(rental.items) { item in
                        HStack {
                            Text(item.equipment?.displayName ?? "Unbekannt")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            .navigationTitle("Rückgabe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Abschließen") {
                        completeReturn()
                    }
                }
            }
        }
    }

    private func completeReturn() {
        rental.status = .returned
        rental.actualEndDate = Date()
        rental.depositReturned = returnDeposit

        if !returnNotes.isEmpty {
            rental.notes += "\n\nRückgabe: \(returnNotes)"
        }

        // Mark equipment as available again
        for item in rental.items {
            item.equipment?.isAvailable = true
        }

        do {
            try modelContext.save()
            toastManager.success("Rückgabe abgeschlossen")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to complete return")
            toastManager.error("Fehler bei der Rückgabe")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RentalDetailView(rental: Rental(
            rentalNumber: "R-2024-001",
            plannedStartDate: Date(),
            plannedEndDate: Date().addingDays(3),
            status: .active,
            customer: nil,
            totalPrice: 150.0
        ))
    }
    .environmentObject(ToastManager())
}
