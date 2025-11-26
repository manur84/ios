//
//  RentalListView.swift
//  MediaTechManager
//
//  Ausleihliste
//

import SwiftUI
import SwiftData

struct RentalListView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Rental.plannedStartDate, order: .reverse) private var allRentals: [Rental]

    // MARK: - State

    @State private var searchText = ""
    @State private var selectedFilter: RentalFilter = .all
    @State private var showNewRental = false

    enum RentalFilter: String, CaseIterable {
        case all = "Alle"
        case active = "Aktiv"
        case overdue = "Überfällig"
        case reserved = "Reserviert"
        case returned = "Zurück"
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if filteredRentals.isEmpty {
                    emptyState
                } else {
                    rentalList
                }
            }
            .navigationTitle("Ausleihen")
            .searchable(text: $searchText, prompt: "Suchen...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showNewRental = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewRental) {
                NewRentalView()
            }
        }
    }

    // MARK: - Filter Picker

    private var filterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(RentalFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
    }

    // MARK: - Rental List

    private var rentalList: some View {
        VStack(spacing: 0) {
            filterPicker
                .padding(.vertical, Spacing.sm)

            List {
                ForEach(filteredRentals) { rental in
                    NavigationLink(value: rental) {
                        RentalRow(rental: rental)
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Rental.self) { rental in
                RentalDetailView(rental: rental)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView.noRentals {
            showNewRental = true
        }
    }

    // MARK: - Filtering

    private var filteredRentals: [Rental] {
        var result = allRentals

        // Status Filter
        switch selectedFilter {
        case .all:
            break
        case .active:
            result = result.filter { $0.status == .active }
        case .overdue:
            result = result.filter { $0.status == .overdue }
        case .reserved:
            result = result.filter { $0.status == .reserved }
        case .returned:
            result = result.filter { $0.status == .returned }
        }

        // Search
        if !searchText.isEmpty {
            result = result.filter { rental in
                rental.rentalNumber.localizedCaseInsensitiveContains(searchText) ||
                (rental.customer?.fullName.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        return result
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.labelMedium)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(isSelected ? Color(hex: "007AFF") : Color.backgroundSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Rental Row

struct RentalRow: View {
    let rental: Rental

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Status Indicator
            Circle()
                .fill(rental.status.fallbackColor)
                .frame(width: 12, height: 12)

            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack {
                    Text(rental.customer?.fullName ?? "Unbekannt")
                        .font(.titleMedium)
                        .foregroundStyle(.primary)

                    Spacer()

                    Text(rental.rentalNumber)
                        .font(.monoSmall)
                        .foregroundStyle(.secondary)
                }

                Text(rental.dateRangeString)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("\(rental.equipmentCount) Gerät(e)")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)

                    Spacer()

                    StatusBadge(status: rental.status)
                }
            }
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    RentalListView()
        .modelContainer(for: [Rental.self, Customer.self, Equipment.self])
        .environmentObject(ToastManager())
}
