//
//  ConditionManagementView.swift
//  MediaTechManager
//
//  Zustände-Verwaltung
//

import SwiftUI
import SwiftData

struct ConditionManagementView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Condition.sortOrder) private var conditions: [Condition]

    // MARK: - State

    @State private var showAddSheet = false
    @State private var editingCondition: Condition?

    // MARK: - Body

    var body: some View {
        List {
            ForEach(conditions) { condition in
                ConditionRow(condition: condition)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingCondition = condition
                    }
            }
            .onDelete(perform: deleteConditions)
            .onMove(perform: moveConditions)
        }
        .navigationTitle("Zustände")
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
            ConditionEditSheet(condition: nil)
        }
        .sheet(item: $editingCondition) { condition in
            ConditionEditSheet(condition: condition)
        }
        .overlay {
            if conditions.isEmpty {
                EmptyStateView(
                    icon: "checkmark.seal",
                    title: "Keine Zustände",
                    message: "Fügen Sie Zustände hinzu, um den Gerätezustand zu dokumentieren."
                )
            }
        }
    }

    // MARK: - Actions

    private func deleteConditions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(conditions[index])
        }
        toastManager.success("Zustand gelöscht")
    }

    private func moveConditions(from source: IndexSet, to destination: Int) {
        var reorderedConditions = conditions
        reorderedConditions.move(fromOffsets: source, toOffset: destination)

        for (index, condition) in reorderedConditions.enumerated() {
            condition.sortOrder = index
        }
    }
}

// MARK: - Condition Row

struct ConditionRow: View {
    let condition: Condition

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color(hex: condition.colorHex).opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: condition.iconName)
                    .foregroundStyle(Color(hex: condition.colorHex))
            }

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(condition.name)
                    .font(.bodyMedium)

                if let description = condition.descriptionText, !description.isEmpty {
                    Text(description)
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

// MARK: - Condition Edit Sheet

struct ConditionEditSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    let condition: Condition?
    private var isNew: Bool { condition == nil }

    @State private var name = ""
    @State private var descriptionText = ""
    @State private var selectedIcon = "checkmark.seal"
    @State private var selectedColor = "34C759"

    private let availableIcons = [
        "checkmark.seal", "checkmark.seal.fill",
        "star.fill", "hand.thumbsup.fill",
        "exclamationmark.triangle", "exclamationmark.triangle.fill",
        "wrench.fill", "bandage.fill",
        "xmark.seal", "xmark.seal.fill",
        "questionmark.circle", "info.circle"
    ]

    private let availableColors = [
        "34C759", "007AFF", "FFD60A", "FF9500",
        "FF3B30", "5856D6", "8E8E93", "00C7BE"
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
            }
            .navigationTitle(isNew ? "Neuer Zustand" : "Zustand bearbeiten")
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
        guard let condition else { return }
        name = condition.name
        descriptionText = condition.descriptionText ?? ""
        selectedIcon = condition.iconName
        selectedColor = condition.colorHex
    }

    private func save() {
        let targetCondition = condition ?? Condition(
            name: name,
            iconName: selectedIcon,
            colorHex: selectedColor
        )

        targetCondition.name = name
        targetCondition.descriptionText = descriptionText.isEmpty ? nil : descriptionText
        targetCondition.iconName = selectedIcon
        targetCondition.colorHex = selectedColor

        if isNew {
            modelContext.insert(targetCondition)
        }

        do {
            try modelContext.save()
            toastManager.success(isNew ? "Zustand erstellt" : "Zustand gespeichert")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to save condition")
            toastManager.error("Speichern fehlgeschlagen")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ConditionManagementView()
    }
    .modelContainer(for: Condition.self)
    .environmentObject(ToastManager())
}
