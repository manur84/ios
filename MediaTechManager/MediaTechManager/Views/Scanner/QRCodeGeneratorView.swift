//
//  QRCodeGeneratorView.swift
//  MediaTechManager
//
//  Erweiterter QR-Code Generator für Geräte mit Label-Druck-Funktion
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGeneratorView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let equipment: Equipment

    // MARK: - State

    @State private var qrCodeImage: UIImage?
    @State private var showShareSheet = false
    @State private var showLabelOptions = false
    @State private var selectedLabelSize: LabelSize = .medium
    @State private var includeDetails = true
    @State private var labelImage: UIImage?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Equipment Info Header
                    equipmentHeader
                    
                    // QR Code Display
                    qrCodeDisplay
                    
                    // QR Code Info
                    qrCodeInfo
                    
                    // Label Preview (if enabled)
                    if showLabelOptions {
                        labelOptionsSection
                    }

                    Spacer(minLength: Spacing.xl)

                    // Actions
                    actionButtons
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("QR-Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            showLabelOptions.toggle()
                        } label: {
                            Label(
                                showLabelOptions ? "Label ausblenden" : "Label erstellen",
                                systemImage: "tag"
                            )
                        }
                        
                        Button {
                            copyToClipboard()
                        } label: {
                            Label("Code kopieren", systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                generateQRCode()
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = showLabelOptions ? labelImage : qrCodeImage {
                    ShareSheet(items: [image])
                }
            }
            .onChange(of: selectedLabelSize) { _, _ in
                generateLabelImage()
            }
            .onChange(of: includeDetails) { _, _ in
                generateLabelImage()
            }
        }
    }
    
    // MARK: - Equipment Header
    
    private var equipmentHeader: some View {
        HStack(spacing: Spacing.md) {
            // Equipment Image
            if let imageData = equipment.primaryImage,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            } else {
                RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium)
                    .fill(Color.backgroundSecondary)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "shippingbox.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
            }
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.displayName)
                    .font(.titleMedium)
                    .lineLimit(2)

                Text(equipment.inventoryNumber)
                    .font(.monoSmall)
                    .foregroundStyle(.secondary)
                
                if let category = equipment.category {
                    Badge(category.name, color: Color(hex: category.colorHex), icon: category.iconName)
                }
            }
            
            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }
    
    // MARK: - QR Code Display
    
    private var qrCodeDisplay: some View {
        VStack(spacing: Spacing.md) {
            if let image = qrCodeImage {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 220)
                    .padding(Spacing.lg)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            } else {
                ProgressView()
                    .frame(width: 220, height: 220)
            }
        }
    }

    // MARK: - QR Code Info

    private var qrCodeInfo: some View {
        VStack(spacing: Spacing.sm) {
            // Content Type Badge
            HStack {
                Image(systemName: "qrcode")
                Text("MTM Equipment Code")
            }
            .font(.labelMedium)
            .foregroundStyle(.secondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .background(Color.backgroundSecondary)
            .clipShape(Capsule())
            
            // Content Preview
            VStack(spacing: Spacing.xxs) {
                Text("Enthält:")
                    .font(.labelSmall)
                    .foregroundStyle(.tertiary)

                Text(qrCodeContent)
                    .font(.monoSmall)
                    .foregroundStyle(.secondary)
                    .padding(Spacing.sm)
                    .frame(maxWidth: .infinity)
                    .background(Color.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
            }
        }
    }
    
    // MARK: - Label Options Section
    
    private var labelOptionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Label-Einstellungen")
                .font(.titleMedium)
            
            // Size Picker
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Größe")
                    .font(.labelMedium)
                    .foregroundStyle(.secondary)
                
                Picker("Größe", selection: $selectedLabelSize) {
                    ForEach(LabelSize.allCases, id: \.self) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Include Details Toggle
            Toggle(isOn: $includeDetails) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Details einschließen")
                        .font(.bodyMedium)
                    Text("Name, Inventarnummer und Kategorie")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Label Preview
            if let label = labelImage {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Vorschau")
                        .font(.labelMedium)
                        .foregroundStyle(.secondary)
                    
                    Image(uiImage: label)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 150)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
                        .overlay {
                            RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
        .onAppear {
            generateLabelImage()
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: Spacing.sm) {
            PrimaryButton(
                showLabelOptions ? "Label teilen" : "QR-Code teilen",
                icon: "square.and.arrow.up"
            ) {
                showShareSheet = true
            }

            SecondaryButton("Drucken", icon: "printer") {
                printQRCode()
            }
            
            if showLabelOptions {
                SecondaryButton("Label in Fotos speichern", icon: "photo") {
                    saveLabelToPhotos()
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.bottom, Spacing.lg)
    }

    // MARK: - QR Code Content

    private var qrCodeContent: String {
        QRCodeService.equipmentQRContent(equipment)
    }

    // MARK: - Generate QR Code

    private func generateQRCode() {
        qrCodeImage = QRCodeService.generateQRCode(from: qrCodeContent, size: 500)
    }
    
    // MARK: - Generate Label Image
    
    private func generateLabelImage() {
        guard let qrImage = qrCodeImage else { return }
        
        let size = selectedLabelSize.size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        labelImage = renderer.image { context in
            // Background
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // QR Code
            let qrSize: CGFloat
            let qrOrigin: CGPoint
            
            if includeDetails {
                qrSize = min(size.width * 0.5, size.height * 0.7)
                qrOrigin = CGPoint(x: 10, y: (size.height - qrSize) / 2)
            } else {
                qrSize = min(size.width, size.height) - 20
                qrOrigin = CGPoint(x: (size.width - qrSize) / 2, y: (size.height - qrSize) / 2)
            }
            
            qrImage.draw(in: CGRect(origin: qrOrigin, size: CGSize(width: qrSize, height: qrSize)))
            
            // Details (if enabled)
            if includeDetails {
                let textX = qrOrigin.x + qrSize + 10
                let textWidth = size.width - textX - 10
                
                // Equipment Name
                let nameFont = UIFont.boldSystemFont(ofSize: selectedLabelSize.fontSize)
                let nameAttributes: [NSAttributedString.Key: Any] = [
                    .font: nameFont,
                    .foregroundColor: UIColor.black
                ]
                let nameRect = CGRect(x: textX, y: 10, width: textWidth, height: 40)
                equipment.displayName.draw(in: nameRect, withAttributes: nameAttributes)
                
                // Inventory Number
                let invFont = UIFont.monospacedSystemFont(ofSize: selectedLabelSize.fontSize - 2, weight: .medium)
                let invAttributes: [NSAttributedString.Key: Any] = [
                    .font: invFont,
                    .foregroundColor: UIColor.darkGray
                ]
                let invRect = CGRect(x: textX, y: 50, width: textWidth, height: 30)
                equipment.inventoryNumber.draw(in: invRect, withAttributes: invAttributes)
                
                // Category (if available)
                if let category = equipment.category {
                    let catFont = UIFont.systemFont(ofSize: selectedLabelSize.fontSize - 4)
                    let catAttributes: [NSAttributedString.Key: Any] = [
                        .font: catFont,
                        .foregroundColor: UIColor.gray
                    ]
                    let catRect = CGRect(x: textX, y: size.height - 30, width: textWidth, height: 20)
                    category.name.draw(in: catRect, withAttributes: catAttributes)
                }
            }
        }
    }

    // MARK: - Print QR Code

    private func printQRCode() {
        guard let image = showLabelOptions ? labelImage : qrCodeImage else { return }

        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .photo
        printInfo.jobName = "QR-Code \(equipment.inventoryNumber)"

        printController.printInfo = printInfo
        printController.printingItem = image

        printController.present(animated: true) { _, completed, error in
            if let error = error {
                Logger.error(error, message: "Print failed")
                toastManager.error("Drucken fehlgeschlagen")
            } else if completed {
                toastManager.success("QR-Code gedruckt")
            }
        }
    }
    
    // MARK: - Copy to Clipboard
    
    private func copyToClipboard() {
        UIPasteboard.general.string = qrCodeContent
        toastManager.success("Code kopiert")
        HapticManager.light()
    }
    
    // MARK: - Save to Photos
    
    private func saveLabelToPhotos() {
        guard let image = labelImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        toastManager.success("Label gespeichert")
        HapticManager.medium()
    }
}

// MARK: - Label Size

enum LabelSize: String, CaseIterable {
    case small = "Klein"
    case medium = "Mittel"
    case large = "Groß"
    
    var displayName: String { rawValue }
    
    var size: CGSize {
        switch self {
        case .small: return CGSize(width: 200, height: 100)
        case .medium: return CGSize(width: 300, height: 150)
        case .large: return CGSize(width: 400, height: 200)
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .small: return 10
        case .medium: return 14
        case .large: return 18
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    QRCodeGeneratorView(equipment: Equipment(name: "Canon EOS R5"))
        .environmentObject(ToastManager())
}
