//
//  LockScreenView.swift
//  MediaTechManager
//
//  Sperrbildschirm mit PIN/Biometrie
//

import SwiftUI
import LocalAuthentication

struct LockScreenView: View {

    // MARK: - Environment

    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - State

    @State private var pin = ""
    @State private var isAuthenticating = false
    @State private var shakeTrigger = 0

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: Spacing.xxl) {
                Spacer()

                // App Icon
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color(hex: "007AFF"))

                // Title
                VStack(spacing: Spacing.xs) {
                    Text("App gesperrt")
                        .font(.titleLarge)

                    Text("Geben Sie Ihre PIN ein")
                        .font(.bodyMedium)
                        .foregroundStyle(.secondary)
                }

                // PIN Dots
                HStack(spacing: Spacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .fill(index < pin.count ? Color(hex: "007AFF") : Color.gray.opacity(0.3))
                            .frame(width: 16, height: 16)
                    }
                }
                .shake(trigger: shakeTrigger)

                // Keypad
                keypad

                Spacer()

                // Biometric Button
                if appState.biometricEnabled {
                    Button {
                        authenticateWithBiometrics()
                    } label: {
                        Image(systemName: biometricIcon)
                            .font(.system(size: 40))
                            .foregroundStyle(Color(hex: "007AFF"))
                    }
                    .padding(.bottom, Spacing.xxl)
                }
            }
            .padding()
        }
        .onAppear {
            if appState.biometricEnabled {
                authenticateWithBiometrics()
            }
        }
    }

    // MARK: - Keypad

    private var keypad: some View {
        VStack(spacing: Spacing.md) {
            ForEach(0..<3) { row in
                HStack(spacing: Spacing.lg) {
                    ForEach(1...3, id: \.self) { col in
                        let number = row * 3 + col
                        keypadButton(String(number))
                    }
                }
            }

            HStack(spacing: Spacing.lg) {
                // Empty
                Color.clear
                    .frame(width: 70, height: 70)

                // 0
                keypadButton("0")

                // Delete
                Button {
                    if !pin.isEmpty {
                        pin.removeLast()
                    }
                } label: {
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .foregroundStyle(.primary)
                        .frame(width: 70, height: 70)
                }
            }
        }
    }

    private func keypadButton(_ number: String) -> some View {
        Button {
            addDigit(number)
        } label: {
            Text(number)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.primary)
                .frame(width: 70, height: 70)
                .background(Color.backgroundSecondary)
                .clipShape(Circle())
        }
    }

    // MARK: - Actions

    private func addDigit(_ digit: String) {
        guard pin.count < 4 else { return }

        pin += digit

        if pin.count == 4 {
            validatePIN()
        }
    }

    private func validatePIN() {
        if KeychainManager.shared.validatePIN(pin) {
            appState.unlock()
        } else {
            shakeTrigger += 1
            pin = ""
            toastManager.error("Falsche PIN")
        }
    }

    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return
        }

        isAuthenticating = true

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "App entsperren"
        ) { success, _ in
            DispatchQueue.main.async {
                isAuthenticating = false
                if success {
                    appState.unlock()
                }
            }
        }
    }

    // MARK: - Computed

    private var biometricIcon: String {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        switch context.biometryType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return "lock.fill"
        }
    }
}

// MARK: - Preview

#Preview {
    LockScreenView()
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
