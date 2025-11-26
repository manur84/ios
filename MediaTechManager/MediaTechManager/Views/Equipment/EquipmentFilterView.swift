//
//  EquipmentFilterView.swift
//  MediaTechManager
//
//  Filter für Geräteliste
//

import SwiftUI
import SwiftData

struct EquipmentFilterView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Queries

    @Query(sort: \Category.sortOrder) private var categories: [Category]
    @Query(sort: \Condition.sortOrder) private var conditions: [Condition]
    @Query(sort: \Location.sortOrder) private var locations: [Location]

    // MARK: - State

    @State private var selectedCategory: Category?
    @State private var selectedCondition: Condition?
    @State private var selectedLocation: Location?
    @State private var showAvailableOnly = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                // Verfügbarkeit
                Section {
                    Toggle("Nur verfügbare Geräte", isOn: $showAvailableOnly)
                }

                // Kategorie
                Section("Kategorie") {
                    Picker("Kategorie", selection: $selectedCategory) {
                        Text("Alle").tag(nil as Category?)
                        ForEach(categories) { category in
                            HStack {
                                Image(systemName: category.iconName)
                                    .foregroundStyle(Color(hex: category.colorHex))
                                Text(category.name)
                            }
                            .tag(category as Category?)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                // Zustand
                Section("Zustand") {
                    Picker("Zustand", selection: $selectedCondition) {
                        Text("Alle").tag(nil as Condition?)
                        ForEach(conditions) { condition in
                            HStack {
                                Image(systemName: condition.iconName)
                                    .foregroundStyle(Color(hex: condition.colorHex))
                                Text(condition.name)
                            }
                            .tag(condition as Condition?)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                // Standort
                Section("Standort") {
                    Picker("Standort", selection: $selectedLocation) {
                        Text("Alle").tag(nil as Location?)
                        ForEach(locations) { location in
                            HStack {
                                Image(systemName: location.iconName)
                                    .foregroundStyle(Color(hex: location.colorHex))
                                Text(location.name)
                            }
                            .tag(location as Location?)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                // Reset
                Section {
                    Button("Filter zurücksetzen") {
                        resetFilters()
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func resetFilters() {
        selectedCategory = nil
        selectedCondition = nil
        selectedLocation = nil
        showAvailableOnly = false
    }
}

// MARK: - Preview

#Preview {
    EquipmentFilterView()
        .modelContainer(for: [Category.self, Condition.self, Location.self])
}
