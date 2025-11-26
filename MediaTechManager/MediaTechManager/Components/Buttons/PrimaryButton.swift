//
//  PrimaryButton.swift
//  MediaTechManager
//
//  Primärer Button mit Loading-State
//

import SwiftUI

struct PrimaryButton: View {

    // MARK: - Properties

    let title: String
    let icon: String?
    let isLoading: Bool
    let isFullWidth: Bool
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initializer

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.9)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(.titleMedium)
                }
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: Layout.buttonHeight)
            .padding(.horizontal, isFullWidth ? 0 : Spacing.lg)
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        }
        .disabled(isLoading || !isEnabled)
        .animation(.buttonPress, value: isEnabled)
        .animation(.buttonPress, value: isLoading)
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        if !isEnabled {
            return .gray.opacity(0.3)
        }
        return Color(hex: "007AFF") // brandPrimary Fallback
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PrimaryButton("Speichern", icon: "checkmark") {
            // Action
        }

        PrimaryButton("Laden...", isLoading: true) {
            // Action
        }

        PrimaryButton("Deaktiviert") {
            // Action
        }
        .disabled(true)

        PrimaryButton("Kompakt", icon: "plus", isFullWidth: false) {
            // Action
        }
    }
    .padding()
}
