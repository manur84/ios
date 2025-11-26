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

    // MARK: - Queries

    @Query private var equipment: [Equipment]
    @Query private var rentals: [Rental]
    @Query private var customers: [Customer]

    // MARK: - State

    @State private var showNewEquipment = false
    @State private var showNewRental = false
    @State private var showScanner = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Quick Stats
                    statsSection

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

                        Button {
                            showScanner = true
                        } label: {
                            Label("QR-Code scannen", systemImage: "qrcode.viewfinder")
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
            .fullScreenCover(isPresented: $showScanner) {
                QRCodeScannerView()
            }
        }
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
                    showScanner = true
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
