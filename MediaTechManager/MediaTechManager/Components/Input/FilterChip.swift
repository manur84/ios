//
//  FilterChip.swift
//  MediaTechManager
//
//  Filter-Chip für Auswahl
//

import SwiftUI

struct FilterChip: View {

    // MARK: - Properties

    let title: String
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.labelMedium)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(isSelected ? Color(hex: "007AFF") : Color.backgroundSecondary)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Chip with Icon

struct FilterChipWithIcon: View {

    // MARK: - Properties

    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.labelMedium)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color(hex: "007AFF") : Color.backgroundSecondary)
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Chip Group

struct FilterChipGroup<T: Hashable & CustomStringConvertible>: View {

    // MARK: - Properties

    let items: [T]
    @Binding var selection: T?
    let allowDeselection: Bool

    // MARK: - Initializer

    init(items: [T], selection: Binding<T?>, allowDeselection: Bool = true) {
        self.items = items
        self._selection = selection
        self.allowDeselection = allowDeselection
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(items, id: \.self) { item in
                    FilterChip(
                        title: item.description,
                        isSelected: selection == item
                    ) {
                        withAnimation(.snappy) {
                            if selection == item && allowDeselection {
                                selection = nil
                            } else {
                                selection = item
                            }
                        }
                        HapticManager.selection()
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.lg) {
        HStack {
            FilterChip(title: "Alle", isSelected: true) {}
            FilterChip(title: "Kameras", isSelected: false) {}
            FilterChip(title: "Objektive", isSelected: false) {}
        }

        HStack {
            FilterChipWithIcon(title: "Verfügbar", icon: "checkmark.circle", isSelected: true) {}
            FilterChipWithIcon(title: "Verliehen", icon: "arrow.right", isSelected: false) {}
        }
    }
    .padding()
}
