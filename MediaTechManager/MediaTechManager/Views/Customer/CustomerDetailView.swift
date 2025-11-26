//
//  CustomerDetailView.swift
//  MediaTechManager
//
//  Kunden-Detailansicht
//

import SwiftUI
import SwiftData

struct CustomerDetailView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let customer: Customer

    // MARK: - State

    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.sectionSpacing) {
                // Main Info
                mainInfoSection

                // Contact
                contactSection

                // Address
                if customer.hasAddress {
                    addressSection
                }

                // Statistics
                statisticsSection

                // Rental History
                rentalHistorySection

                // Notes
                if !customer.notes.isEmpty {
                    notesSection
                }
            }
            .padding(Spacing.md)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle(customer.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Bearbeiten", systemImage: "pencil")
                    }

                    Divider()

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            CustomerEditView(customer: customer)
        }
        .confirmationDialog(
            "Kunde löschen?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Löschen", role: .destructive) {
                deleteCustomer()
            }
        } message: {
            Text("Alle Ausleihen dieses Kunden werden ebenfalls gelöscht.")
        }
    }

    // MARK: - Main Info Section

    private var mainInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(customer.fullName)
                        .font(.titleLarge)

                    if let company = customer.company {
                        Text(company)
                            .font(.bodyMedium)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                CustomerTypeBadge(type: customer.customerType)
            }

            if let customerNumber = customer.customerNumber {
                HStack {
                    Text("Kundennummer")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                    Text(customerNumber)
                        .font(.labelSmall)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Contact Section

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Kontakt")
                .font(.titleMedium)

            VStack(spacing: Spacing.xs) {
                // Email
                ContactRow(
                    icon: "envelope",
                    label: "E-Mail",
                    value: customer.email,
                    action: {
                        if let url = URL(string: "mailto:\(customer.email)") {
                            UIApplication.shared.open(url)
                        }
                    }
                )

                // Phone
                if let phone = customer.phone {
                    ContactRow(
                        icon: "phone",
                        label: "Telefon",
                        value: phone,
                        action: {
                            if let url = URL(string: "tel:\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }

                // Mobile
                if let mobile = customer.mobile {
                    ContactRow(
                        icon: "iphone",
                        label: "Mobil",
                        value: mobile,
                        action: {
                            if let url = URL(string: "tel:\(mobile)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Address Section

    private var addressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Adresse")
                .font(.titleMedium)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                if let street = customer.street {
                    Text(street)
                }
                if let zip = customer.zipCode, let city = customer.city {
                    Text("\(zip) \(city)")
                }
                if let country = customer.country {
                    Text(country)
                }
            }
            .font(.bodyMedium)
            .foregroundStyle(.secondary)

            Button {
                openInMaps()
            } label: {
                Label("In Karten öffnen", systemImage: "map")
                    .font(.bodySmall)
            }
        }
        .cardStyle()
    }

    // MARK: - Statistics Section

    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Statistiken")
                .font(.titleMedium)

            HStack(spacing: Spacing.md) {
                StatBox(
                    title: "Ausleihen",
                    value: "\(customer.rentals.count)"
                )

                StatBox(
                    title: "Aktiv",
                    value: "\(customer.activeRentals.count)"
                )

                StatBox(
                    title: "Umsatz",
                    value: customer.totalRevenue.formatted(.currency(code: "EUR"))
                )
            }
        }
        .cardStyle()
    }

    // MARK: - Rental History Section

    private var rentalHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Ausleihen")
                    .font(.titleMedium)

                Spacer()

                Text("\(customer.rentals.count)")
                    .font(.labelMedium)
                    .foregroundStyle(.secondary)
            }

            if customer.rentals.isEmpty {
                Text("Noch keine Ausleihen")
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, Spacing.sm)
            } else {
                ForEach(customer.rentals.prefix(5)) { rental in
                    NavigationLink {
                        RentalDetailView(rental: rental)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: Spacing.xxs) {
                                Text("#\(rental.rentalNumber)")
                                    .font(.bodyMedium)
                                    .foregroundStyle(.primary)

                                Text(rental.plannedStartDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.labelSmall)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            StatusBadge(rental.status.displayName, color: Color(hex: rental.status.colorHex))

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, Spacing.xxs)
                    }

                    if rental != customer.rentals.prefix(5).last {
                        Divider()
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

            Text(customer.notes)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }

    // MARK: - Actions

    private func deleteCustomer() {
        modelContext.delete(customer)
        toastManager.success("Kunde gelöscht")
    }

    private func openInMaps() {
        var addressComponents: [String] = []
        if let street = customer.street { addressComponents.append(street) }
        if let zip = customer.zipCode { addressComponents.append(zip) }
        if let city = customer.city { addressComponents.append(city) }

        let address = addressComponents.joined(separator: ", ")
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = URL(string: "http://maps.apple.com/?address=\(encodedAddress)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Contact Row

struct ContactRow: View {
    let icon: String
    let label: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(Color(hex: "007AFF"))

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                    Text(value)
                        .font(.bodyMedium)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, Spacing.xxs)
        }
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text(value)
                .font(.titleMedium)
                .foregroundStyle(.primary)

            Text(title)
                .font(.labelSmall)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sm)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
    }
}

// MARK: - Customer Type Badge

struct CustomerTypeBadge: View {
    let type: CustomerType

    var body: some View {
        Text(type.displayName)
            .font(.labelSmall)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xxs)
            .background(Color(hex: type.colorHex).opacity(0.15))
            .foregroundStyle(Color(hex: type.colorHex))
            .clipShape(Capsule())
    }
}

// MARK: - Customer Type Extension

extension Customer {
    var hasAddress: Bool {
        street != nil || zipCode != nil || city != nil
    }

    var activeRentals: [Rental] {
        rentals.filter { $0.status == .active || $0.status == .overdue }
    }

    var totalRevenue: Double {
        rentals.filter { $0.status == .returned }.reduce(0) { $0 + $1.totalPrice }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CustomerDetailView(customer: Customer(
            firstName: "Max",
            lastName: "Mustermann",
            email: "max@example.com",
            customerType: .private
        ))
    }
    .environmentObject(ToastManager())
}
