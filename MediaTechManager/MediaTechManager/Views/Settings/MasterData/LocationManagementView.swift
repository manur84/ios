//
//  LocationManagementView.swift
//  MediaTechManager
//
//  Standort-Verwaltung
//

import SwiftUI
import SwiftData

struct LocationManagementView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Location.sortOrder) private var locations: [Location]

    // MARK: - State

    @State private var showAddSheet = false
    @State private var editingLocation: Location?

    // MARK: - Body

    var body: some View {
        List {
            ForEach(locations) { location in
                LocationRow(location: location)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingLocation = location
                    }
            }
            .onDelete(perform: deleteLocations)
            .onMove(perform: moveLocations)
        }
        .navigationTitle("Standorte")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $showAddSheet) {
            LocationEditSheet(location: nil)
        }
        .sheet(item: $editingLocation) { location in
            LocationEditSheet(location: location)
        }
        .overlay {
            if locations.isEmpty {
                EmptyStateView(
                    icon: "mappin.circle",
                    title: "Keine Standorte",
                    message: "Fügen Sie Standorte hinzu, um Lagerorte zu verwalten."
                )
            }
        }
    }

    // MARK: - Actions

    private func deleteLocations(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(locations[index])
        }
        toastManager.success("Standort gelöscht")
    }

    private func moveLocations(from source: IndexSet, to destination: Int) {
        var reorderedLocations = locations
        reorderedLocations.move(fromOffsets: source, toOffset: destination)

        for (index, location) in reorderedLocations.enumerated() {
            location.sortOrder = index
        }
    }
}

// MARK: - Location Row

struct LocationRow: View {
    let location: Location

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color(hex: location.colorHex).opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: location.iconName)
                    .foregroundStyle(Color(hex: location.colorHex))
            }

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(location.name)
                    .font(.bodyMedium)

                if let address = location.address, !address.isEmpty {
                    Text(address)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, Spacing.xxs)
    }
}

// MARK: - Location Edit Sheet

struct LocationEditSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    let location: Location?
    private var isNew: Bool { location == nil }

    @State private var name = ""
    @State private var address = ""
    @State private var descriptionText = ""
    @State private var selectedIcon = "mappin.circle"
    @State private var selectedColor = "007AFF"

    private let availableIcons = [
        "mappin.circle", "mappin.circle.fill",
        "building.2", "building.2.fill",
        "house", "house.fill",
        "archivebox", "archivebox.fill",
        "shippingbox", "shippingbox.fill",
        "car", "car.fill",
        "tram", "airplane"
    ]

    private let availableColors = [
        "007AFF", "34C759", "FF9500", "FF3B30",
        "5856D6", "AF52DE", "8E8E93", "00C7BE"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Allgemein") {
                    TextField("Name", text: $name)
                    TextField("Adresse", text: $address)
                    TextField("Beschreibung", text: $descriptionText, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Spacing.sm) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedIcon == icon ? Color(hex: selectedColor).opacity(0.2) : Color.clear)
                                        .frame(width: 40, height: 40)

                                    Image(systemName: icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(selectedIcon == icon ? Color(hex: selectedColor) : .secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, Spacing.xs)
                }

                Section("Farbe") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: Spacing.sm) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 32, height: 32)

                                    if selectedColor == color {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, Spacing.xs)
                }
            }
            .navigationTitle(isNew ? "Neuer Standort" : "Standort bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        save()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                loadData()
            }
        }
    }

    private func loadData() {
        guard let location else { return }
        name = location.name
        address = location.address ?? ""
        descriptionText = location.descriptionText ?? ""
        selectedIcon = location.iconName
        selectedColor = location.colorHex
    }

    private func save() {
        let targetLocation = location ?? Location(
            name: name,
            iconName: selectedIcon,
            colorHex: selectedColor
        )

        targetLocation.name = name
        targetLocation.address = address.isEmpty ? nil : address
        targetLocation.descriptionText = descriptionText.isEmpty ? nil : descriptionText
        targetLocation.iconName = selectedIcon
        targetLocation.colorHex = selectedColor

        if isNew {
            modelContext.insert(targetLocation)
        }

        do {
            try modelContext.save()
            toastManager.success(isNew ? "Standort erstellt" : "Standort gespeichert")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to save location")
            toastManager.error("Speichern fehlgeschlagen")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LocationManagementView()
    }
    .modelContainer(for: Location.self)
    .environmentObject(ToastManager())
}
