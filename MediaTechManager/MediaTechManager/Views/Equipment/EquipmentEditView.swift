//
//  EquipmentEditView.swift
//  MediaTechManager
//
//  Gerät hinzufügen/bearbeiten
//

import SwiftUI
import SwiftData
import PhotosUI

struct EquipmentEditView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Queries

    @Query(sort: \Category.sortOrder) private var categories: [Category]
    @Query(sort: \Condition.sortOrder) private var conditions: [Condition]
    @Query(sort: \Location.sortOrder) private var locations: [Location]

    // MARK: - Properties

    let equipment: Equipment?
    private var isNew: Bool { equipment == nil }

    // MARK: - State

    @State private var name = ""
    @State private var manufacturer = ""
    @State private var model = ""
    @State private var descriptionText = ""
    @State private var inventoryNumber = ""
    @State private var serialNumber = ""
    @State private var barcode = ""

    @State private var selectedCategory: Category?
    @State private var selectedCondition: Condition?
    @State private var selectedLocation: Location?

    @State private var purchasePrice: Double?
    @State private var dailyRate: Double?
    @State private var replacementValue: Double?
    @State private var purchaseDate = Date()

    @State private var notes = ""

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var imageData: [Data] = []

    @State private var isSaving = false

    // MARK: - Initializer

    init(equipment: Equipment?) {
        self.equipment = equipment
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                // Bilder
                Section("Bilder") {
                    imagesSection
                }

                // Grunddaten
                Section("Grunddaten") {
                    TextField("Name *", text: $name)
                    TextField("Hersteller", text: $manufacturer)
                    TextField("Modell", text: $model)
                    TextField("Beschreibung", text: $descriptionText, axis: .vertical)
                        .lineLimit(3...6)
                }

                // Identifikation
                Section("Identifikation") {
                    HStack {
                        TextField("Inventarnummer", text: $inventoryNumber)
                        Button {
                            inventoryNumber = appState.nextInventoryNumber()
                        } label: {
                            Image(systemName: "wand.and.stars")
                        }
                    }
                    TextField("Seriennummer", text: $serialNumber)
                    TextField("Barcode", text: $barcode)
                }

                // Klassifizierung
                Section("Klassifizierung") {
                    Picker("Kategorie", selection: $selectedCategory) {
                        Text("Keine").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }

                    Picker("Zustand", selection: $selectedCondition) {
                        Text("Keine Angabe").tag(nil as Condition?)
                        ForEach(conditions) { condition in
                            Text(condition.name).tag(condition as Condition?)
                        }
                    }

                    Picker("Standort", selection: $selectedLocation) {
                        Text("Kein Standort").tag(nil as Location?)
                        ForEach(locations) { location in
                            Text(location.name).tag(location as Location?)
                        }
                    }
                }

                // Finanzen
                Section("Finanzen") {
                    HStack {
                        Text("Kaufpreis")
                        Spacer()
                        TextField("€", value: $purchasePrice, format: .currency(code: "EUR"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Tagesmiete")
                        Spacer()
                        TextField("€", value: $dailyRate, format: .currency(code: "EUR"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Ersatzwert")
                        Spacer()
                        TextField("€", value: $replacementValue, format: .currency(code: "EUR"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    DatePicker("Kaufdatum", selection: $purchaseDate, displayedComponents: .date)
                }

                // Notizen
                Section("Notizen") {
                    TextField("Interne Notizen", text: $notes, axis: .vertical)
                        .lineLimit(3...10)
                }
            }
            .navigationTitle(isNew ? "Neues Gerät" : "Gerät bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        save()
                    }
                    .disabled(name.isEmpty || isSaving)
                }
            }
            .onAppear {
                loadEquipmentData()
            }
        }
    }

    // MARK: - Images Section

    private var imagesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                // Existing Images
                ForEach(Array(imageData.enumerated()), id: \.offset) { index, data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    imageData.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .red)
                                }
                                .offset(x: 8, y: -8)
                            }
                    }
                }

                // Add Button
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: Constants.Limits.maxImagesPerEquipment - imageData.count,
                    matching: .images
                ) {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                        Text("Hinzufügen")
                            .font(.caption)
                    }
                    .foregroundStyle(Color(hex: "007AFF"))
                    .frame(width: 80, height: 80)
                    .background(Color.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
                }
                .onChange(of: selectedPhotos) { _, newItems in
                    loadPhotos(newItems)
                }
            }
            .padding(.vertical, Spacing.xs)
        }
    }

    // MARK: - Load Data

    private func loadEquipmentData() {
        guard let equipment else {
            // Generate inventory number for new equipment
            if inventoryNumber.isEmpty {
                inventoryNumber = appState.nextInventoryNumber()
            }
            return
        }

        name = equipment.name
        manufacturer = equipment.manufacturer
        model = equipment.model
        descriptionText = equipment.descriptionText
        inventoryNumber = equipment.inventoryNumber
        serialNumber = equipment.serialNumber
        barcode = equipment.barcode ?? ""
        selectedCategory = equipment.category
        selectedCondition = equipment.condition
        selectedLocation = equipment.location
        purchasePrice = equipment.purchasePrice
        dailyRate = equipment.dailyRate
        replacementValue = equipment.replacementValue
        purchaseDate = equipment.purchaseDate ?? Date()
        notes = equipment.notes
        imageData = equipment.images
    }

    private func loadPhotos(_ items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    // Compress image
                    if let uiImage = UIImage(data: data),
                       let compressed = uiImage.jpegData(compressionQuality: 0.5) {
                        await MainActor.run {
                            imageData.append(compressed)
                        }
                    }
                }
            }
            await MainActor.run {
                selectedPhotos = []
            }
        }
    }

    // MARK: - Save

    private func save() {
        isSaving = true

        let targetEquipment = equipment ?? Equipment(name: name)

        targetEquipment.name = name
        targetEquipment.manufacturer = manufacturer
        targetEquipment.model = model
        targetEquipment.descriptionText = descriptionText
        targetEquipment.inventoryNumber = inventoryNumber
        targetEquipment.serialNumber = serialNumber
        targetEquipment.barcode = barcode.isEmpty ? nil : barcode
        targetEquipment.category = selectedCategory
        targetEquipment.condition = selectedCondition
        targetEquipment.location = selectedLocation
        targetEquipment.purchasePrice = purchasePrice
        targetEquipment.dailyRate = dailyRate
        targetEquipment.replacementValue = replacementValue
        targetEquipment.purchaseDate = purchaseDate
        targetEquipment.notes = notes
        targetEquipment.images = imageData
        targetEquipment.touch()

        if isNew {
            modelContext.insert(targetEquipment)
        }

        do {
            try modelContext.save()
            toastManager.success(isNew ? "Gerät erstellt" : "Änderungen gespeichert")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to save equipment")
            toastManager.error("Speichern fehlgeschlagen")
            isSaving = false
        }
    }
}

// MARK: - Preview

#Preview {
    EquipmentEditView(equipment: nil)
        .modelContainer(for: [Equipment.self, Category.self, Condition.self, Location.self])
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
