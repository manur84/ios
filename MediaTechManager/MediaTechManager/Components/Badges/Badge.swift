//
//  Badge.swift
//  MediaTechManager
//
//  Allgemeines Badge-Komponente
//

import SwiftUI

struct Badge: View {

    // MARK: - Properties

    let text: String
    let color: Color
    let icon: String?

    // MARK: - Initializer

    init(_ text: String, color: Color, icon: String? = nil) {
        self.text = text
        self.color = color
        self.icon = icon
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
            }

            Text(text)
                .font(.labelSmall)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xxs)
        .background(color.opacity(0.15))
        .foregroundStyle(color)
        .clipShape(Capsule())
    }
}

// MARK: - Availability Badge

struct AvailabilityBadge: View {
    let isAvailable: Bool

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Circle()
                .fill(isAvailable ? Color.green : Color.red)
                .frame(width: 8, height: 8)

            Text(isAvailable ? "Verfügbar" : "Verliehen")
                .font(.labelSmall)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xxs)
        .background((isAvailable ? Color.green : Color.red).opacity(0.15))
        .foregroundStyle(isAvailable ? Color.green : Color.red)
        .clipShape(Capsule())
    }
}

// MARK: - Count Badge

struct CountBadge: View {
    let count: Int
    let color: Color

    init(_ count: Int, color: Color = Color(hex: "007AFF")) {
        self.count = count
        self.color = color
    }

    var body: some View {
        Text("\(count)")
            .font(.labelSmall)
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, 2)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.md) {
        Badge("Kamera", color: .blue, icon: "camera.fill")
        Badge("Neu", color: .green)

        AvailabilityBadge(isAvailable: true)
        AvailabilityBadge(isAvailable: false)

        CountBadge(5)
        CountBadge(12, color: .red)
    }
    .padding()
}
