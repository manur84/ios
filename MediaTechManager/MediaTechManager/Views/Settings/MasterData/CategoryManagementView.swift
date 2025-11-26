//
//  CategoryManagementView.swift
//  MediaTechManager
//
//  Kategorie-Verwaltung
//

import SwiftUI
import SwiftData

struct CategoryManagementView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Category.sortOrder) private var categories: [Category]

    // MARK: - State

    @State private var showAddSheet = false
    @State private var editingCategory: Category?

    // MARK: - Body

    var body: some View {
        List {
            ForEach(categories) { category in
                CategoryRow(category: category)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingCategory = category
                    }
            }
            .onDelete(perform: deleteCategories)
            .onMove(perform: moveCategories)
        }
        .navigationTitle("Kategorien")
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
            CategoryEditSheet(category: nil)
        }
        .sheet(item: $editingCategory) { category in
            CategoryEditSheet(category: category)
        }
        .overlay {
            if categories.isEmpty {
                EmptyStateView(
                    icon: "folder",
                    title: "Keine Kategorien",
                    message: "Fügen Sie Kategorien hinzu, um Geräte zu organisieren."
                )
            }
        }
    }

    // MARK: - Actions

    private func deleteCategories(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
        toastManager.success("Kategorie gelöscht")
    }

    private func moveCategories(from source: IndexSet, to destination: Int) {
        var reorderedCategories = categories
        reorderedCategories.move(fromOffsets: source, toOffset: destination)

        for (index, category) in reorderedCategories.enumerated() {
            category.sortOrder = index
        }
    }
}

// MARK: - Category Row

struct CategoryRow: View {
    let category: Category

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color(hex: category.colorHex).opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: category.iconName)
                    .foregroundStyle(Color(hex: category.colorHex))
            }

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(category.name)
                    .font(.bodyMedium)

                if !category.descriptionText.isEmpty {
                    Text(category.descriptionText)
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

// MARK: - Category Edit Sheet

struct CategoryEditSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    let category: Category?
    private var isNew: Bool { category == nil }

    @State private var name = ""
    @State private var descriptionText = ""
    @State private var selectedIcon = "folder"
    @State private var selectedColor = "007AFF"

    private let availableIcons = [
        "folder", "camera.fill", "video.fill", "mic.fill",
        "headphones", "speaker.wave.3.fill", "lightbulb.fill",
        "cable.connector", "battery.100", "powerplug.fill",
        "display", "laptopcomputer", "desktopcomputer",
        "keyboard", "computermouse", "printer.fill",
        "externaldrive.fill", "memorychip", "cpu",
        "antenna.radiowaves.left.and.right", "wifi",
        "bolt.fill", "wrench.and.screwdriver.fill"
    ]

    private let availableColors = [
        "007AFF", "34C759", "FF9500", "FF3B30",
        "5856D6", "AF52DE", "FF2D55", "00C7BE",
        "8E8E93", "FFD60A", "30B0C7", "64D2FF"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Allgemein") {
                    TextField("Name", text: $name)

                    TextField("Beschreibung", text: $descriptionText)
                }

                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: Spacing.sm) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedIcon == icon ? Color(hex: selectedColor).opacity(0.2) : Color.clear)
                                        .frame(width: 44, height: 44)

                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .foregroundStyle(selectedIcon == icon ? Color(hex: selectedColor) : .secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, Spacing.xs)
                }

                Section("Farbe") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: Spacing.sm) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 36, height: 36)

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

                Section("Vorschau") {
                    HStack(spacing: Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: selectedColor).opacity(0.15))
                                .frame(width: 50, height: 50)

                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundStyle(Color(hex: selectedColor))
                        }

                        Text(name.isEmpty ? "Kategoriename" : name)
                            .font(.bodyLarge)
                    }
                }
            }
            .navigationTitle(isNew ? "Neue Kategorie" : "Kategorie bearbeiten")
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
        guard let category else { return }
        name = category.name
        descriptionText = category.descriptionText
        selectedIcon = category.iconName
        selectedColor = category.colorHex
    }

    private func save() {
        let targetCategory = category ?? Category(
            name: name,
            iconName: selectedIcon,
            colorHex: selectedColor
        )

        targetCategory.name = name
        targetCategory.descriptionText = descriptionText
        targetCategory.iconName = selectedIcon
        targetCategory.colorHex = selectedColor

        if isNew {
            modelContext.insert(targetCategory)
        }

        do {
            try modelContext.save()
            toastManager.success(isNew ? "Kategorie erstellt" : "Kategorie gespeichert")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to save category")
            toastManager.error("Speichern fehlgeschlagen")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CategoryManagementView()
    }
    .modelContainer(for: Category.self)
    .environmentObject(ToastManager())
}
