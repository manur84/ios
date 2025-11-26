//
//  SecondaryButton.swift
//  MediaTechManager
//
//  Sekundärer Button
//

import SwiftUI

struct SecondaryButton: View {

    // MARK: - Properties

    let title: String
    let icon: String?
    let isDestructive: Bool
    let isFullWidth: Bool
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initializer

    init(
        _ title: String,
        icon: String? = nil,
        isDestructive: Bool = false,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.isFullWidth = isFullWidth
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.titleSmall)
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: Layout.minButtonHeight)
            .padding(.horizontal, isFullWidth ? 0 : Spacing.md)
            .background(Color.backgroundSecondary)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium)
                    .stroke(borderColor, lineWidth: Layout.borderWidth)
            )
        }
        .disabled(!isEnabled)
    }

    // MARK: - Computed Properties

    private var foregroundColor: Color {
        if !isEnabled {
            return .gray
        }
        return isDestructive ? Color(hex: "FF3B30") : Color(hex: "007AFF")
    }

    private var borderColor: Color {
        foregroundColor.opacity(0.3)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        SecondaryButton("Abbrechen", icon: "xmark") {
            // Action
        }

        SecondaryButton("Löschen", icon: "trash", isDestructive: true) {
            // Action
        }

        SecondaryButton("Kompakt", isFullWidth: false) {
            // Action
        }
    }
    .padding()
}
