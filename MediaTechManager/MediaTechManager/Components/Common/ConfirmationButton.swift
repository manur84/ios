//
//  ConfirmationButton.swift
//  MediaTechManager
//
//  Button mit Bestätigungsdialog
//

import SwiftUI

struct ConfirmationButton<Label: View>: View {

    // MARK: - Properties

    let title: String
    let message: String
    let confirmLabel: String
    let role: ButtonRole?
    let action: () -> Void
    let label: () -> Label

    // MARK: - State

    @State private var showConfirmation = false

    // MARK: - Initializer

    init(
        title: String,
        message: String,
        confirmLabel: String = "Bestätigen",
        role: ButtonRole? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.title = title
        self.message = message
        self.confirmLabel = confirmLabel
        self.role = role
        self.action = action
        self.label = label
    }

    // MARK: - Body

    var body: some View {
        Button(role: role) {
            showConfirmation = true
        } label: {
            label()
        }
        .confirmationDialog(
            title,
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {
            Button(confirmLabel, role: role) {
                action()
            }
        } message: {
            Text(message)
        }
    }
}

// MARK: - Delete Button

struct DeleteButton: View {
    let itemName: String
    let action: () -> Void

    var body: some View {
        ConfirmationButton(
            title: "\(itemName) löschen?",
            message: "Diese Aktion kann nicht rückgängig gemacht werden.",
            confirmLabel: "Löschen",
            role: .destructive,
            action: action
        ) {
            Label("Löschen", systemImage: "trash")
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.lg) {
        ConfirmationButton(
            title: "Aktion bestätigen",
            message: "Möchten Sie diese Aktion wirklich ausführen?",
            action: { print("Bestätigt") }
        ) {
            Text("Aktion ausführen")
        }
        .buttonStyle(.borderedProminent)

        DeleteButton(itemName: "Gerät") {
            print("Gelöscht")
        }
    }
    .padding()
}
