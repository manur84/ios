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

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            StatusBadge(status: .reserved)
            StatusBadge(status: .active)
            StatusBadge(status: .overdue)
            StatusBadge(status: .returned)
        }
    }
    .padding()
}
