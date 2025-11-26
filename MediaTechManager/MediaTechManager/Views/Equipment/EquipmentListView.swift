//
//  EquipmentListView.swift
//  MediaTechManager
//
//  Geräteliste mit Suche, Filter und Sortierung
//

import SwiftUI
import SwiftData

struct EquipmentListView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Equipment.name) private var allEquipment: [Equipment]

    // MARK: - State

    @State private var searchText = ""
    @State private var showFilters = false
    @State private var showAddEquipment = false
    @State private var viewMode: ViewMode = .list

    enum ViewMode {
        case list, grid
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if filteredEquipment.isEmpty {
                    emptyState
                } else {
                    equipmentList
                }
            }
            .navigationTitle("Inventar")
            .searchable(text: $searchText, prompt: "Suchen...")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        withAnimation {
                            viewMode = viewMode == .list ? .grid : .list
                        }
                    } label: {
                        Image(systemName: viewMode == .list ? "square.grid.2x2" : "list.bullet")
                    }

                    Button {
                        showAddEquipment = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                EquipmentFilterView()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAddEquipment) {
                EquipmentEditView(equipment: nil)
            }
        }
    }

    // MARK: - Equipment List

    @ViewBuilder
    private var equipmentList: some View {
        switch viewMode {
        case .list:
            List {
                ForEach(filteredEquipment) { equipment in
                    NavigationLink(value: equipment) {
                        EquipmentRow(equipment: equipment)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteEquipment(equipment)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Equipment.self) { equipment in
                EquipmentDetailView(equipment: equipment)
            }

        case .grid:
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 160), spacing: Spacing.md)
                ], spacing: Spacing.md) {
                    ForEach(filteredEquipment) { equipment in
                        NavigationLink(value: equipment) {
                            EquipmentGridCard(equipment: equipment)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.md)
            }
            .navigationDestination(for: Equipment.self) { equipment in
                EquipmentDetailView(equipment: equipment)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        EmptyStateView.noEquipment {
            showAddEquipment = true
        }
    }

    // MARK: - Filtering

    private var filteredEquipment: [Equipment] {
        var result = allEquipment

        if !searchText.isEmpty {
            result = result.filter { equipment in
                equipment.name.localizedCaseInsensitiveContains(searchText) ||
                equipment.manufacturer.localizedCaseInsensitiveContains(searchText) ||
                equipment.model.localizedCaseInsensitiveContains(searchText) ||
                equipment.inventoryNumber.localizedCaseInsensitiveContains(searchText) ||
                equipment.serialNumber.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    // MARK: - Actions

    private func deleteEquipment(_ equipment: Equipment) {
        modelContext.delete(equipment)
        toastManager.success("Gerät gelöscht")
    }
}

// MARK: - Equipment Row

struct EquipmentRow: View {
    let equipment: Equipment

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Thumbnail
            equipmentImage
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))

            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.name)
                    .font(.titleMedium)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("\(equipment.manufacturer) \(equipment.model)")
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: Spacing.xs) {
                    if let category = equipment.category {
                        Badge(category.name, color: Color(hex: category.colorHex))
                    }
                }
            }

            Spacer()

            // Availability
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                AvailabilityBadge(isAvailable: equipment.isAvailable)

                if let price = equipment.dailyRate {
                    Text("\(price, format: .currency(code: "EUR"))/Tag")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(equipment.name), \(equipment.isAvailable ? "verfügbar" : "verliehen")")
    }

    @ViewBuilder
    private var equipmentImage: some View {
        if let imageData = equipment.images.first,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall)
                .fill(Color.backgroundSecondary)
                .overlay {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.tertiary)
                }
        }
    }
}

// MARK: - Equipment Grid Card

struct EquipmentGridCard: View {
    let equipment: Equipment

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Image
            equipmentImage
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))

            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.name)
                    .font(.titleSmall)
                    .lineLimit(1)

                Text(equipment.manufacturer)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                AvailabilityBadge(isAvailable: equipment.isAvailable)
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
    }

    @ViewBuilder
    private var equipmentImage: some View {
        if let imageData = equipment.images.first,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Rectangle()
                .fill(Color.backgroundSecondary)
                .overlay {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.tertiary)
                }
        }
    }
}

// MARK: - Preview

#Preview {
    EquipmentListView()
        .modelContainer(for: Equipment.self)
        .environmentObject(ToastManager())
}
