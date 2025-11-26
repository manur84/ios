//
//  ImageService.swift
//  MediaTechManager
//
//  Bildverarbeitung und -optimierung
//

import Foundation
import UIKit
import CoreImage

enum ImageService {

    // MARK: - Configuration

    struct CompressionConfig {
        let maxWidth: CGFloat
        let maxHeight: CGFloat
        let compressionQuality: CGFloat

        static let thumbnail = CompressionConfig(
            maxWidth: 200,
            maxHeight: 200,
            compressionQuality: 0.6
        )

        static let medium = CompressionConfig(
            maxWidth: 800,
            maxHeight: 800,
            compressionQuality: 0.7
        )

        static let full = CompressionConfig(
            maxWidth: 1920,
            maxHeight: 1920,
            compressionQuality: 0.8
        )
    }

    // MARK: - Compression

    /// Komprimiert ein Bild mit den angegebenen Einstellungen
    static func compress(
        _ image: UIImage,
        config: CompressionConfig = .medium
    ) -> Data? {
        guard let resized = resize(image, maxWidth: config.maxWidth, maxHeight: config.maxHeight) else {
            return nil
        }

        return resized.jpegData(compressionQuality: config.compressionQuality)
    }

    /// Komprimiert Bilddaten mit den angegebenen Einstellungen
    static func compress(
        data: Data,
        config: CompressionConfig = .medium
    ) -> Data? {
        guard let image = UIImage(data: data) else {
            return nil
        }

        return compress(image, config: config)
    }

    // MARK: - Resizing

    /// Ändert die Größe eines Bildes unter Beibehaltung des Seitenverhältnisses
    static func resize(
        _ image: UIImage,
        maxWidth: CGFloat,
        maxHeight: CGFloat
    ) -> UIImage? {
        let size = image.size

        // Check if resizing is needed
        if size.width <= maxWidth && size.height <= maxHeight {
            return image
        }

        // Calculate new size
        let widthRatio = maxWidth / size.width
        let heightRatio = maxHeight / size.height
        let ratio = min(widthRatio, heightRatio)

        let newSize = CGSize(
            width: size.width * ratio,
            height: size.height * ratio
        )

        // Draw resized image
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resized
    }

    // MARK: - Thumbnail Generation

    /// Erstellt ein Thumbnail eines Bildes
    static func generateThumbnail(
        from data: Data,
        size: CGFloat = 100
    ) -> UIImage? {
        guard let image = UIImage(data: data) else {
            return nil
        }

        return resize(image, maxWidth: size, maxHeight: size)
    }

    /// Erstellt Thumbnails für mehrere Bilder
    static func generateThumbnails(
        from dataArray: [Data],
        size: CGFloat = 100
    ) -> [UIImage] {
        dataArray.compactMap { generateThumbnail(from: $0, size: size) }
    }

    // MARK: - Image Analysis

    /// Analysiert ein Bild und gibt Metadaten zurück
    static func analyzeImage(_ data: Data) -> ImageMetadata? {
        guard let image = UIImage(data: data) else {
            return nil
        }

        let fileSize = data.count
        let width = Int(image.size.width * image.scale)
        let height = Int(image.size.height * image.scale)

        // Detect dominant color
        let dominantColor = detectDominantColor(in: image)

        return ImageMetadata(
            width: width,
            height: height,
            fileSize: fileSize,
            dominantColor: dominantColor
        )
    }

    /// Erkennt die dominante Farbe in einem Bild
    static func detectDominantColor(in image: UIImage) -> UIColor? {
        guard let inputImage = CIImage(image: image) else {
            return nil
        }

        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )

        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: inputImage,
                kCIInputExtentKey: extentVector
            ]
        ),
        let outputImage = filter.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }

    // MARK: - Image Processing

    /// Wendet einen Farbfilter auf ein Bild an (für Vorschau)
    static func applyFilter(_ filter: ImageFilter, to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }

        let filteredImage: CIImage?

        switch filter {
        case .none:
            return image

        case .grayscale:
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(0.0, forKey: kCIInputSaturationKey)
            filteredImage = filter?.outputImage

        case .sepia:
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(0.8, forKey: kCIInputIntensityKey)
            filteredImage = filter?.outputImage

        case .vibrant:
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(1.5, forKey: kCIInputSaturationKey)
            filter?.setValue(1.1, forKey: kCIInputContrastKey)
            filteredImage = filter?.outputImage
        }

        guard let output = filteredImage else {
            return nil
        }

        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    // MARK: - Validation

    /// Prüft ob die Bilddaten gültig sind
    static func isValidImage(_ data: Data) -> Bool {
        UIImage(data: data) != nil
    }

    /// Prüft ob die Dateigröße innerhalb des Limits liegt
    static func isWithinSizeLimit(_ data: Data, maxSizeMB: Double = 10) -> Bool {
        let maxBytes = Int(maxSizeMB * 1024 * 1024)
        return data.count <= maxBytes
    }
}

// MARK: - Image Metadata

struct ImageMetadata {
    let width: Int
    let height: Int
    let fileSize: Int
    let dominantColor: UIColor?

    var resolution: String {
        "\(width) × \(height)"
    }

    var fileSizeFormatted: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(fileSize))
    }

    var aspectRatio: CGFloat {
        guard height > 0 else { return 0 }
        return CGFloat(width) / CGFloat(height)
    }
}

// MARK: - Image Filter

enum ImageFilter: String, CaseIterable {
    case none = "Original"
    case grayscale = "Schwarzweiß"
    case sepia = "Sepia"
    case vibrant = "Lebendig"
}
