//
//  EmptyStateView.swift
//  MediaTechManager
//
//  Leerzustand-Ansicht
//

import SwiftUI

struct EmptyStateView: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    // MARK: - Initializer

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            // Icon
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(.tertiary)

            // Text
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(.titleLarge)
                    .foregroundStyle(.primary)

                Text(message)
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
            }

            // Action Button
            if let actionTitle, let action {
                Button(action: action) {
                    Label(actionTitle, systemImage: "plus")
                        .font(.titleSmall)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, Spacing.sm)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Predefined Empty States

extension EmptyStateView {

    /// Leerer Equipment-Zustand
    static func noEquipment(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "shippingbox",
            title: "Keine Geräte",
            message: "Fügen Sie Ihr erstes Gerät hinzu, um mit der Inventarisierung zu beginnen.",
            actionTitle: "Gerät hinzufügen",
            action: action
        )
    }

    /// Leerer Rental-Zustand
    static func noRentals(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "arrow.left.arrow.right",
            title: "Keine Ausleihen",
            message: "Erstellen Sie Ihre erste Ausleihe, um Geräte zu verleihen.",
            actionTitle: "Ausleihe erstellen",
            action: action
        )
    }

    /// Leerer Customer-Zustand
    static func noCustomers(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "person.2",
            title: "Keine Kunden",
            message: "Legen Sie Ihren ersten Kunden an.",
            actionTitle: "Kunde hinzufügen",
            action: action
        )
    }

    /// Keine Suchergebnisse
    static func noSearchResults(query: String) -> EmptyStateView {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "Keine Ergebnisse",
            message: "Keine Einträge gefunden für \"\(query)\""
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        EmptyStateView.noEquipment {
            // Action
        }
    }
}
