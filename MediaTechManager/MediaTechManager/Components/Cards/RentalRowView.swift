//
//  RentalRowView.swift
//  MediaTechManager
//
//  Ausleihe-Zeile für Listen
//

import SwiftUI

struct RentalRowView: View {

    // MARK: - Properties

    let rental: Rental

    // MARK: - Body

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Status Icon
            statusIcon

            // Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack {
                    Text("#\(rental.rentalNumber)")
                        .font(.bodyMedium)
                        .foregroundStyle(.primary)

                    if rental.isOverdue {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }

                if let customer = rental.customer {
                    Text(customer.fullName)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }

                Text(dateRangeText)
                    .font(.labelSmall)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Right Side
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                StatusBadge(status: rental.status)

                Text("\(rental.items.count) Gerät(e)")
                    .font(.labelSmall)
                    .foregroundStyle(.secondary)

                Text(rental.totalPrice, format: .currency(code: "EUR"))
                    .font(.labelMedium)
                    .foregroundStyle(.primary)
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Status Icon

    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(rental.status.fallbackColor.opacity(0.15))
                .frame(width: 44, height: 44)

            Image(systemName: rental.status.icon)
                .foregroundStyle(rental.status.fallbackColor)
        }
    }

    // MARK: - Date Range Text

    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        let start = formatter.string(from: rental.plannedStartDate)
        let end = formatter.string(from: rental.plannedEndDate)

        return "\(start) - \(end)"
    }
}

// MARK: - Preview

#Preview {
    List {
        RentalRowView(rental: Rental(
            rentalNumber: "R-2024-001",
            plannedStartDate: Date(),
            plannedEndDate: Date().addingDays(3),
            status: .active,
            customer: nil,
            totalPrice: 150.0
        ))

        RentalRowView(rental: Rental(
            rentalNumber: "R-2024-002",
            plannedStartDate: Date().addingDays(-5),
            plannedEndDate: Date().addingDays(-2),
            status: .overdue,
            customer: nil,
            totalPrice: 250.0
        ))
    }
}
