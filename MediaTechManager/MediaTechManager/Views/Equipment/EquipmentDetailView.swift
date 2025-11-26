//
//  EquipmentDetailView.swift
//  MediaTechManager
//
//  Geräte-Detailansicht
//

import SwiftUI

struct EquipmentDetailView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let equipment: Equipment

    // MARK: - State

    @State private var showEditSheet = false
    @State private var showQRCode = false
    @State private var showDeleteConfirmation = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.sectionSpacing) {
                // Image Gallery
                if !equipment.images.isEmpty {
                    imageGallery
                }

                // Main Info
                mainInfoSection

                // Details
                detailsSection

                // Financial
                if equipment.purchasePrice != nil || equipment.dailyRate != nil {
                    financialSection
                }

                // Notes
                if !equipment.notes.isEmpty {
                    notesSection
                }

                // Actions
                actionsSection
            }
            .padding(Spacing.md)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle(equipment.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Bearbeiten", systemImage: "pencil")
                    }

                    Button {
                        showQRCode = true
                    } label: {
                        Label("QR-Code", systemImage: "qrcode")
                    }

                    Divider()

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EquipmentEditView(equipment: equipment)
        }
        .sheet(isPresented: $showQRCode) {
            QRCodeGeneratorView(equipment: equipment)
        }
        .confirmationDialog(
            "Gerät löschen?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Löschen", role: .destructive) {
                deleteEquipment()
            }
        } message: {
            Text("Diese Aktion kann nicht rückgängig gemacht werden.")
        }
    }

    // MARK: - Image Gallery

    private var imageGallery: some View {
        TabView {
            ForEach(Array(equipment.images.enumerated()), id: \.offset) { _, data in
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
        .frame(height: 250)
        .tabViewStyle(.page)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }

    // MARK: - Main Info Section

    private var mainInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(equipment.displayName)
                        .font(.titleLarge)

                    if !equipment.model.isEmpty {
                        Text(equipment.model)
                            .font(.bodyMedium)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                AvailabilityBadge(isAvailable: equipment.isAvailable)
            }

            if let category = equipment.category {
                Badge(category.name, color: Color(hex: category.colorHex), icon: category.iconName)
            }
        }
        .cardStyle()
    }

    // MARK: - Details Section

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Details")
                .font(.titleMedium)

            VStack(spacing: Spacing.xs) {
                DetailRow(label: "Inventarnummer", value: equipment.inventoryNumber)

                if !equipment.serialNumber.isEmpty {
                    DetailRow(label: "Seriennummer", value: equipment.serialNumber)
                }

                if let condition = equipment.condition {
                    DetailRow(label: "Zustand", value: condition.name)
                }

                if let location = equipment.location {
                    DetailRow(label: "Standort", value: location.name)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Financial Section

    private var financialSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Finanzen")
                .font(.titleMedium)

            VStack(spacing: Spacing.xs) {
                if let price = equipment.purchasePrice {
                    DetailRow(
                        label: "Kaufpreis",
                        value: price.formatted(.currency(code: "EUR"))
                    )
                }

                if let rate = equipment.dailyRate {
                    DetailRow(
                        label: "Tagesmiete",
                        value: rate.formatted(.currency(code: "EUR"))
                    )
                }

                if let value = equipment.replacementValue {
                    DetailRow(
                        label: "Ersatzwert",
                        value: value.formatted(.currency(code: "EUR"))
                    )
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Notes Section

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Notizen")
                .font(.titleMedium)

            Text(equipment.notes)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(spacing: Spacing.sm) {
            if equipment.isAvailable {
                PrimaryButton("Ausleihen", icon: "arrow.right") {
                    // Start rental
                }
            }

            SecondaryButton("QR-Code anzeigen", icon: "qrcode") {
                showQRCode = true
            }
        }
    }

    // MARK: - Actions

    private func deleteEquipment() {
        modelContext.delete(equipment)
        toastManager.success("Gerät gelöscht")
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.bodyMedium)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, Spacing.xxs)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EquipmentDetailView(equipment: Equipment(name: "Canon EOS R5"))
    }
    .environmentObject(ToastManager())
}
