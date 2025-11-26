//
//  CustomerRowView.swift
//  MediaTechManager
//
//  Kunden-Zeile für Listen
//

import SwiftUI

struct CustomerRowView: View {

    // MARK: - Properties

    let customer: Customer

    // MARK: - Body

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Avatar
            customerAvatar

            // Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(customer.fullName)
                    .font(.bodyMedium)
                    .foregroundStyle(.primary)

                if let company = customer.company {
                    Text(company)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }

                Text(customer.email)
                    .font(.labelSmall)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Right Side
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                CustomerTypeBadge(type: customer.customerType)

                if !customer.rentals.isEmpty {
                    Text("\(customer.rentals.count) Ausleihe(n)")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Customer Avatar

    private var customerAvatar: some View {
        ZStack {
            Circle()
                .fill(Color(hex: customer.customerType.colorHex).opacity(0.15))
                .frame(width: 44, height: 44)

            Text(customer.initials)
                .font(.titleSmall)
                .foregroundStyle(Color(hex: customer.customerType.colorHex))
        }
    }
}

// MARK: - Preview

#Preview {
    List {
        CustomerRowView(customer: Customer(
            firstName: "Max",
            lastName: "Mustermann",
            email: "max@example.com",
            customerType: .private
        ))

        CustomerRowView(customer: Customer(
            firstName: "Anna",
            lastName: "Schmidt",
            email: "anna@firma.de",
            customerType: .business
        ))
    }
}
