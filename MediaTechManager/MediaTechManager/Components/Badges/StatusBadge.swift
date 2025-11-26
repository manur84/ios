//
//  StatusBadge.swift
//  MediaTechManager
//
//  Status-Badge für Ausleihen
//

import SwiftUI

struct StatusBadge: View {

    // MARK: - Properties

    let status: RentalStatus

    // MARK: - Body

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.fallbackColor)
                .frame(width: 8, height: 8)

            Text(status.displayName)
                .font(.labelMedium)
                .foregroundStyle(status.fallbackColor)
        }
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, Spacing.xxs)
        .background(status.fallbackColor.opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Generic Badge

struct Badge: View {

    let text: String
    let color: Color
    let icon: String?

    init(_ text: String, color: Color = Color(hex: "007AFF"), icon: String? = nil) {
        self.text = text
        self.color = color
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
            }

            Text(text)
                .font(.labelSmall)
        }
        .foregroundStyle(color)
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, Spacing.xxs)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Availability Badge

struct AvailabilityBadge: View {

    let isAvailable: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isAvailable ? Color(hex: "34C759") : Color(hex: "FF9500"))
                .frame(width: 8, height: 8)

            Text(isAvailable ? "Verfügbar" : "Verliehen")
                .font(.labelSmall)
                .foregroundStyle(isAvailable ? Color(hex: "34C759") : Color(hex: "FF9500"))
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            StatusBadge(status: .reserved)
            StatusBadge(status: .active)
            StatusBadge(status: .overdue)
            StatusBadge(status: .returned)
        }

        HStack(spacing: 8) {
            Badge("4K", color: Color(hex: "007AFF"))
            Badge("Premium", color: Color(hex: "AF52DE"), icon: "star.fill")
        }

        HStack(spacing: 16) {
            AvailabilityBadge(isAvailable: true)
            AvailabilityBadge(isAvailable: false)
        }
    }
    .padding()
}
