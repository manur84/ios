//
//  QRCodeService.swift
//  MediaTechManager
//
//  Service für QR-Code Generierung und Parsing
//

import UIKit
import CoreImage.CIFilterBuiltins

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
        // Use both ID and inventory number for flexibility
        "mtm://equipment/\(equipment.id.uuidString)/\(equipment.inventoryNumber)"
    }
    
    /// Generate QR code content for rental
    static func rentalQRContent(_ rental: Rental) -> String {
        "mtm://rental/\(rental.id.uuidString)/\(rental.rentalNumber)"
    }

    /// Parse QR code content
    static func parseQRContent(_ content: String) -> QRContentType? {
        // Check for MTM scheme
        guard content.lowercased().hasPrefix("mtm://") else {
            // Try to parse as legacy format or plain inventory number
            return parseLegacyContent(content)
        }

        let components = content
            .replacingOccurrences(of: "mtm://", with: "", options: .caseInsensitive)
            .components(separatedBy: "/")

        guard !components.isEmpty else {
            return nil
        }

        switch components[0].lowercased() {
        case "equipment":
            if components.count >= 2 {
                // Check if second component is UUID or inventory number
                if UUID(uuidString: components[1]) != nil {
                    return .equipmentById(id: components[1])
                } else {
                    return .equipment(inventoryNumber: components[1])
                }
            }
        case "rental":
            if components.count >= 2 {
                return .rental(rentalId: components[1])
            }
        default:
            break
        }

        return nil
    }
    
    /// Parse legacy or plain content
    private static func parseLegacyContent(_ content: String) -> QRContentType? {
        // Check if it's a valid inventory number format (e.g., CAM-001, INV-00001)
        let inventoryPattern = #"^[A-Z]{2,4}-\d{3,5}$"#
        if content.range(of: inventoryPattern, options: .regularExpression) != nil {
            return .equipment(inventoryNumber: content)
        }
        
        // Check if it's a UUID
        if UUID(uuidString: content) != nil {
            return .equipmentById(id: content)
        }
        
        return nil
    }
}

// MARK: - QR Content Type

enum QRContentType: Equatable {
    case equipment(inventoryNumber: String)
    case equipmentById(id: String)
    case rental(rentalId: String)
    
    var description: String {
        switch self {
        case .equipment(let inventoryNumber):
            return "Gerät: \(inventoryNumber)"
        case .equipmentById(let id):
            return "Gerät-ID: \(id.prefix(8))..."
        case .rental(let rentalId):
            return "Ausleihe: \(rentalId.prefix(8))..."
        }
    }
}
