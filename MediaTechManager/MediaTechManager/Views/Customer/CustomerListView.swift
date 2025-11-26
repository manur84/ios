//
//  CustomerListView.swift
//  MediaTechManager
//
//  Kundenliste
//

import SwiftUI
import SwiftData

struct CustomerListView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Customer.lastName) private var allCustomers: [Customer]

    // MARK: - State

    @State private var searchText = ""
    @State private var showAddCustomer = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if filteredCustomers.isEmpty {
                    emptyState
                } else {
                    customerList
                }
            }
            .navigationTitle("Kunden")
            .searchable(text: $searchText, prompt: "Suchen...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddCustomer = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCustomer) {
                CustomerEditView(customer: nil)
            }
        }
    }

    // MARK: - Customer List

    private var customerList: some View {
        List {
            ForEach(filteredCustomers) { customer in
                NavigationLink(value: customer) {
                    CustomerRow(customer: customer)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteCustomer(customer)
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Customer.self) { customer in
            CustomerDetailView(customer: customer)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView.noCustomers {
            showAddCustomer = true
        }
    }

    // MARK: - Filtering

    private var filteredCustomers: [Customer] {
        guard !searchText.isEmpty else { return allCustomers }

        return allCustomers.filter { customer in
            customer.fullName.localizedCaseInsensitiveContains(searchText) ||
            customer.email.localizedCaseInsensitiveContains(searchText) ||
            customer.phone.localizedCaseInsensitiveContains(searchText) ||
            (customer.company?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    // MARK: - Actions

    private func deleteCustomer(_ customer: Customer) {
        guard !customer.hasActiveRentals else {
            toastManager.error("Kunde hat aktive Ausleihen")
            return
        }
        modelContext.delete(customer)
        toastManager.success("Kunde gelöscht")
    }
}

// MARK: - Customer Row

struct CustomerRow: View {
    let customer: Customer

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Avatar
            Circle()
                .fill(Color(hex: "007AFF").opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay {
                    Text(customer.initials)
                        .font(.titleSmall)
                        .foregroundStyle(Color(hex: "007AFF"))
                }

            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(customer.fullName)
                    .font(.titleMedium)
                    .foregroundStyle(.primary)

                if let company = customer.company, !company.isEmpty {
                    Text(company)
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: Spacing.sm) {
                    if !customer.email.isEmpty {
                        Label(customer.email, systemImage: "envelope")
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            // Active Rentals Badge
            if customer.activeRentalsCount > 0 {
                Badge("\(customer.activeRentalsCount) aktiv", color: Color(hex: "34C759"))
            }
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    CustomerListView()
        .modelContainer(for: [Customer.self, Rental.self])
        .environmentObject(ToastManager())
}
