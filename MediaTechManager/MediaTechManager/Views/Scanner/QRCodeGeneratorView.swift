//
//  QRCodeGeneratorView.swift
//  MediaTechManager
//
//  QR-Code Generator für Geräte
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

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                // Equipment Info
                VStack(spacing: Spacing.xs) {
                    Text(equipment.displayName)
                        .font(.titleLarge)
                        .multilineTextAlignment(.center)

                    Text(equipment.inventoryNumber)
                        .font(.bodyMedium)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, Spacing.lg)

                // QR Code
                if let image = qrCodeImage {
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(Spacing.lg)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                } else {
                    ProgressView()
                        .frame(width: 250, height: 250)
                }

                // QR Code Content Info
                VStack(spacing: Spacing.xxs) {
                    Text("Enthält:")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)

                    Text(qrCodeContent)
                        .font(.monoSmall)
                        .foregroundStyle(.secondary)
                        .padding(Spacing.sm)
                        .background(Color.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
                }

                Spacer()

                // Actions
                VStack(spacing: Spacing.sm) {
                    PrimaryButton("Teilen", icon: "square.and.arrow.up") {
                        showShareSheet = true
                    }

                    SecondaryButton("Drucken", icon: "printer") {
                        printQRCode()
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
            .padding(Spacing.md)
            .background(Color.backgroundPrimary)
            .navigationTitle("QR-Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
            .onAppear {
                generateQRCode()
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = qrCodeImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }

    // MARK: - QR Code Content

    private var qrCodeContent: String {
        // Create a unique identifier for the equipment
        "mtm://equipment/\(equipment.inventoryNumber)"
    }

    // MARK: - Generate QR Code

    private func generateQRCode() {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        let data = Data(qrCodeContent.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // High error correction

        guard let outputImage = filter.outputImage else {
            Logger.warning("Failed to generate QR code output image")
            return
        }

        // Scale the QR code
        let scale = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: scale)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            Logger.warning("Failed to create CGImage from QR code")
            return
        }

        qrCodeImage = UIImage(cgImage: cgImage)
    }

    // MARK: - Print QR Code

    private func printQRCode() {
        guard let image = qrCodeImage else { return }

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
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - QR Code Service

enum QRCodeService {

    /// Generate a QR code image from a string
    static func generateQRCode(from string: String, size: CGFloat = 250) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else {
            return nil
        }

        // Calculate scale to achieve desired size
        let scaleX = size / outputImage.extent.width
        let scaleY = size / outputImage.extent.height
        let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = outputImage.transformed(by: scale)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    /// Generate QR code content for equipment
    static func equipmentQRContent(_ equipment: Equipment) -> String {
        "mtm://equipment/\(equipment.inventoryNumber)"
    }

    /// Parse QR code content
    static func parseQRContent(_ content: String) -> QRContentType? {
        guard content.hasPrefix("mtm://") else {
            return nil
        }

        let components = content
            .replacingOccurrences(of: "mtm://", with: "")
            .components(separatedBy: "/")

        guard components.count >= 2 else {
            return nil
        }

        switch components[0] {
        case "equipment":
            return .equipment(inventoryNumber: components[1])
        case "rental":
            return .rental(rentalNumber: components[1])
        default:
            return nil
        }
    }
}

// MARK: - QR Content Type

enum QRContentType {
    case equipment(inventoryNumber: String)
    case rental(rentalNumber: String)
}

// MARK: - Preview

#Preview {
    QRCodeGeneratorView(equipment: Equipment(name: "Canon EOS R5"))
        .environmentObject(ToastManager())
}
