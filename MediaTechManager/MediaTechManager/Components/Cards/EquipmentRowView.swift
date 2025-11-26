//
//  EquipmentRowView.swift
//  MediaTechManager
//
//  Geräte-Zeile für Listen
//

import SwiftUI

struct EquipmentRowView: View {

    // MARK: - Properties

    let equipment: Equipment

    // MARK: - Body

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Image
            equipmentImage

            // Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.displayName)
                    .font(.bodyMedium)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                HStack(spacing: Spacing.xs) {
                    Text(equipment.inventoryNumber)
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)

                    if let category = equipment.category {
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text(category.name)
                            .font(.labelSmall)
                            .foregroundStyle(Color(hex: category.colorHex))
                    }
                }
            }

            Spacer()

            // Status
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                AvailabilityBadge(isAvailable: equipment.isAvailable)

                if let rate = equipment.dailyRate {
                    Text("\(rate.formatted(.currency(code: "EUR")))/Tag")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Equipment Image

    private var equipmentImage: some View {
        Group {
            if let imageData = equipment.images.first,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: equipment.category?.iconName ?? "shippingbox")
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
    }
}

// MARK: - Equipment Grid Item

struct EquipmentGridItem: View {

    // MARK: - Properties

    let equipment: Equipment

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Image
            equipmentImage

            // Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.displayName)
                    .font(.bodyMedium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(equipment.inventoryNumber)
                    .font(.labelSmall)
                    .foregroundStyle(.secondary)

                HStack {
                    AvailabilityBadge(isAvailable: equipment.isAvailable)
                    Spacer()
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    // MARK: - Equipment Image

    private var equipmentImage: some View {
        Group {
            if let imageData = equipment.images.first,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                VStack {
                    Image(systemName: equipment.category?.iconName ?? "shippingbox")
                        .font(.system(size: 30))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundSecondary)
            }
        }
        .frame(height: 120)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
    }
}

// MARK: - Preview

#Preview {
    VStack {
        EquipmentRowView(equipment: Equipment(name: "Canon EOS R5"))

        EquipmentGridItem(equipment: Equipment(name: "Canon EOS R5"))
            .frame(width: 180)
    }
    .padding()
}
