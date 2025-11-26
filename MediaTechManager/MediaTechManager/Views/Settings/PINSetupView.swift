//
//  PINSetupView.swift
//  MediaTechManager
//
//  PIN-Einrichtung und -Änderung
//

import SwiftUI

struct PINSetupView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - State

    @State private var currentPIN = ""
    @State private var newPIN = ""
    @State private var confirmPIN = ""
    @State private var step: SetupStep = .current
    @State private var showError = false
    @State private var errorMessage = ""

    private var hasExistingPIN: Bool {
        KeychainManager.shared.hasPIN
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            Image(systemName: step.icon)
                .font(.system(size: 60))
                .foregroundStyle(Color(hex: "007AFF"))
                .padding(.bottom, Spacing.md)

            // Title
            Text(step.title)
                .font(.titleLarge)

            // Subtitle
            Text(step.subtitle)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)

            // PIN Display
            HStack(spacing: Spacing.md) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < currentInputCount ? Color(hex: "007AFF") : Color.gray.opacity(0.3))
                        .frame(width: 16, height: 16)
                }
            }
            .padding(.vertical, Spacing.lg)

            // Error Message
            if showError {
                Text(errorMessage)
                    .font(.bodySmall)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }

            Spacer()

            // Keypad
            VStack(spacing: Spacing.sm) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: Spacing.sm) {
                        ForEach(1...3, id: \.self) { col in
                            let number = row * 3 + col
                            KeypadButton(number: "\(number)") {
                                handleInput("\(number)")
                            }
                        }
                    }
                }

                HStack(spacing: Spacing.sm) {
                    // Empty
                    Color.clear
                        .frame(width: 80, height: 80)

                    KeypadButton(number: "0") {
                        handleInput("0")
                    }

                    // Delete
                    Button {
                        handleDelete()
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding(.bottom, Spacing.xl)
        }
        .navigationTitle("PIN ändern")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            step = hasExistingPIN ? .current : .new
        }
    }

    // MARK: - Computed Properties

    private var currentInputCount: Int {
        switch step {
        case .current:
            return currentPIN.count
        case .new:
            return newPIN.count
        case .confirm:
            return confirmPIN.count
        }
    }

    // MARK: - Actions

    private func handleInput(_ digit: String) {
        showError = false

        switch step {
        case .current:
            if currentPIN.count < 4 {
                currentPIN += digit
                if currentPIN.count == 4 {
                    validateCurrentPIN()
                }
            }

        case .new:
            if newPIN.count < 4 {
                newPIN += digit
                if newPIN.count == 4 {
                    withAnimation {
                        step = .confirm
                    }
                }
            }

        case .confirm:
            if confirmPIN.count < 4 {
                confirmPIN += digit
                if confirmPIN.count == 4 {
                    validateAndSave()
                }
            }
        }
    }

    private func handleDelete() {
        switch step {
        case .current:
            if !currentPIN.isEmpty {
                currentPIN.removeLast()
            }
        case .new:
            if !newPIN.isEmpty {
                newPIN.removeLast()
            }
        case .confirm:
            if !confirmPIN.isEmpty {
                confirmPIN.removeLast()
            }
        }
    }

    private func validateCurrentPIN() {
        if KeychainManager.shared.validatePIN(currentPIN) {
            withAnimation {
                step = .new
            }
        } else {
            showError = true
            errorMessage = "Falscher PIN"
            currentPIN = ""

            // Haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }

    private func validateAndSave() {
        if newPIN == confirmPIN {
            // Save new PIN
            do {
                try KeychainManager.shared.savePIN(newPIN)
                appState.securityEnabled = true

                toastManager.success("PIN gespeichert")

                // Haptic
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)

                dismiss()
            } catch {
                showError = true
                errorMessage = "Fehler beim Speichern"

                // Haptic
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        } else {
            showError = true
            errorMessage = "PINs stimmen nicht überein"
            confirmPIN = ""

            // Haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}

// MARK: - Setup Step

enum SetupStep {
    case current
    case new
    case confirm

    var title: String {
        switch self {
        case .current:
            return "Aktueller PIN"
        case .new:
            return "Neuer PIN"
        case .confirm:
            return "PIN bestätigen"
        }
    }

    var subtitle: String {
        switch self {
        case .current:
            return "Geben Sie Ihren aktuellen PIN ein"
        case .new:
            return "Geben Sie einen neuen 4-stelligen PIN ein"
        case .confirm:
            return "Bestätigen Sie den neuen PIN"
        }
    }

    var icon: String {
        switch self {
        case .current:
            return "lock"
        case .new:
            return "lock.badge.clock"
        case .confirm:
            return "checkmark.lock"
        }
    }
}

// MARK: - Keypad Button

struct KeypadButton: View {
    let number: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.title)
                .fontWeight(.medium)
                .frame(width: 80, height: 80)
                .background(Color.backgroundSecondary)
                .foregroundStyle(.primary)
                .clipShape(Circle())
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PINSetupView()
    }
    .environmentObject(AppStateManager())
    .environmentObject(ToastManager())
}
