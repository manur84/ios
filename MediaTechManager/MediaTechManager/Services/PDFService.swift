//
//  PDFService.swift
//  MediaTechManager
//
//  PDF-Generierung für Protokolle und Berichte
//

import Foundation
import PDFKit
import UIKit

enum PDFService {

    // MARK: - Generate Rental Protocol

    /// Generiert ein Übergabeprotokoll für eine Ausleihe
    static func generateRentalProtocol(for rental: Rental) -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            context.beginPage()

            let margin: CGFloat = 50
            var yPosition: CGFloat = margin

            // Header
            yPosition = drawHeader(
                in: context.cgContext,
                pageRect: pageRect,
                title: "Übergabeprotokoll",
                subtitle: "Ausleihe #\(rental.rentalNumber)",
                yPosition: yPosition,
                margin: margin
            )

            yPosition += 30

            // Customer Info
            if let customer = rental.customer {
                yPosition = drawSection(
                    in: context.cgContext,
                    title: "Kunde",
                    content: [
                        ("Name", customer.fullName),
                        ("E-Mail", customer.email),
                        ("Telefon", customer.phone ?? "-")
                    ],
                    yPosition: yPosition,
                    margin: margin,
                    pageWidth: pageRect.width
                )
            }

            yPosition += 20

            // Rental Period
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale(identifier: "de_DE")

            yPosition = drawSection(
                in: context.cgContext,
                title: "Zeitraum",
                content: [
                    ("Von", dateFormatter.string(from: rental.plannedStartDate)),
                    ("Bis", dateFormatter.string(from: rental.plannedEndDate)),
                    ("Dauer", "\(rental.numberOfDays) Tag(e)")
                ],
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 20

            // Equipment List
            yPosition = drawEquipmentTable(
                in: context.cgContext,
                items: rental.items,
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 20

            // Financial Summary
            yPosition = drawSection(
                in: context.cgContext,
                title: "Kosten",
                content: [
                    ("Gesamtpreis", formatCurrency(rental.totalPrice)),
                    ("Kaution", formatCurrency(rental.depositAmount))
                ],
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 40

            // Signatures
            drawSignatureFields(
                in: context.cgContext,
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            // Footer
            drawFooter(
                in: context.cgContext,
                pageRect: pageRect,
                margin: margin
            )
        }

        return data
    }

    // MARK: - Generate Return Protocol

    /// Generiert ein Rückgabeprotokoll für eine Ausleihe
    static func generateReturnProtocol(for rental: Rental) -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            context.beginPage()

            let margin: CGFloat = 50
            var yPosition: CGFloat = margin

            // Header
            yPosition = drawHeader(
                in: context.cgContext,
                pageRect: pageRect,
                title: "Rückgabeprotokoll",
                subtitle: "Ausleihe #\(rental.rentalNumber)",
                yPosition: yPosition,
                margin: margin
            )

            yPosition += 30

            // Status Info
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "de_DE")

            var statusContent: [(String, String)] = [
                ("Status", rental.status.displayName)
            ]

            if let actualEnd = rental.actualEndDate {
                statusContent.append(("Rückgabe am", dateFormatter.string(from: actualEnd)))
            }

            statusContent.append(("Kaution zurück", rental.depositReturned ? "Ja" : "Nein"))

            yPosition = drawSection(
                in: context.cgContext,
                title: "Status",
                content: statusContent,
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 20

            // Equipment Condition
            yPosition = drawEquipmentConditionTable(
                in: context.cgContext,
                items: rental.items,
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 40

            // Signatures
            drawSignatureFields(
                in: context.cgContext,
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            // Footer
            drawFooter(
                in: context.cgContext,
                pageRect: pageRect,
                margin: margin
            )
        }

        return data
    }

    // MARK: - Generate Equipment Report

    /// Generiert einen Inventarbericht
    static func generateEquipmentReport(equipment: [Equipment]) -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let data = renderer.pdfData { context in
            context.beginPage()

            let margin: CGFloat = 50
            var yPosition: CGFloat = margin

            // Header
            yPosition = drawHeader(
                in: context.cgContext,
                pageRect: pageRect,
                title: "Inventarbericht",
                subtitle: "Stand: \(Date().formatted(date: .abbreviated, time: .omitted))",
                yPosition: yPosition,
                margin: margin
            )

            yPosition += 30

            // Summary
            let totalValue = equipment.compactMap { $0.purchasePrice }.reduce(0, +)
            let availableCount = equipment.filter { $0.isAvailable }.count

            yPosition = drawSection(
                in: context.cgContext,
                title: "Zusammenfassung",
                content: [
                    ("Gesamtanzahl", "\(equipment.count) Geräte"),
                    ("Verfügbar", "\(availableCount) Geräte"),
                    ("Verliehen", "\(equipment.count - availableCount) Geräte"),
                    ("Gesamtwert", formatCurrency(totalValue))
                ],
                yPosition: yPosition,
                margin: margin,
                pageWidth: pageRect.width
            )

            yPosition += 30

            // Equipment List Header
            let headers = ["Inv.Nr.", "Name", "Kategorie", "Status", "Wert"]
            let columnWidths: [CGFloat] = [80, 180, 100, 70, 70]

            yPosition = drawTableHeader(
                in: context.cgContext,
                headers: headers,
                columnWidths: columnWidths,
                yPosition: yPosition,
                margin: margin
            )

            // Equipment List
            for item in equipment {
                if yPosition > pageRect.height - 100 {
                    context.beginPage()
                    yPosition = margin
                }

                let row = [
                    item.inventoryNumber,
                    item.displayName,
                    item.category?.name ?? "-",
                    item.isAvailable ? "Verfügbar" : "Verliehen",
                    item.purchasePrice.map { formatCurrency($0) } ?? "-"
                ]

                yPosition = drawTableRow(
                    in: context.cgContext,
                    values: row,
                    columnWidths: columnWidths,
                    yPosition: yPosition,
                    margin: margin
                )
            }

            // Footer
            drawFooter(
                in: context.cgContext,
                pageRect: pageRect,
                margin: margin
            )
        }

        return data
    }

    // MARK: - Private Drawing Helpers

    private static func drawHeader(
        in context: CGContext,
        pageRect: CGRect,
        title: String,
        subtitle: String,
        yPosition: CGFloat,
        margin: CGFloat
    ) -> CGFloat {
        var y = yPosition

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        titleString.draw(at: CGPoint(x: margin, y: y))
        y += 30

        // Subtitle
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkGray
        ]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: margin, y: y))
        y += 25

        // Separator Line
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: margin, y: y))
        context.addLine(to: CGPoint(x: pageRect.width - margin, y: y))
        context.strokePath()

        return y + 10
    }

    private static func drawSection(
        in context: CGContext,
        title: String,
        content: [(String, String)],
        yPosition: CGFloat,
        margin: CGFloat,
        pageWidth: CGFloat
    ) -> CGFloat {
        var y = yPosition

        // Section Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        titleString.draw(at: CGPoint(x: margin, y: y))
        y += 22

        // Content
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkGray
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.black
        ]

        for (label, value) in content {
            let labelString = NSAttributedString(string: "\(label):", attributes: labelAttributes)
            labelString.draw(at: CGPoint(x: margin + 10, y: y))

            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            valueString.draw(at: CGPoint(x: margin + 120, y: y))

            y += 18
        }

        return y
    }

    private static func drawEquipmentTable(
        in context: CGContext,
        items: [RentalItem],
        yPosition: CGFloat,
        margin: CGFloat,
        pageWidth: CGFloat
    ) -> CGFloat {
        var y = yPosition

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "Geräte", attributes: titleAttributes)
        titleString.draw(at: CGPoint(x: margin, y: y))
        y += 25

        // Header
        let headers = ["Gerät", "Inv.Nr.", "Tage", "Preis"]
        let columnWidths: [CGFloat] = [200, 100, 50, 80]

        y = drawTableHeader(
            in: context,
            headers: headers,
            columnWidths: columnWidths,
            yPosition: y,
            margin: margin
        )

        // Rows
        for item in items {
            let row = [
                item.equipment?.displayName ?? "Unbekannt",
                item.equipment?.inventoryNumber ?? "-",
                "\(item.days)",
                formatCurrency(item.totalPrice)
            ]

            y = drawTableRow(
                in: context,
                values: row,
                columnWidths: columnWidths,
                yPosition: y,
                margin: margin
            )
        }

        return y
    }

    private static func drawEquipmentConditionTable(
        in context: CGContext,
        items: [RentalItem],
        yPosition: CGFloat,
        margin: CGFloat,
        pageWidth: CGFloat
    ) -> CGFloat {
        var y = yPosition

        // Title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "Geräte-Zustand bei Rückgabe", attributes: titleAttributes)
        titleString.draw(at: CGPoint(x: margin, y: y))
        y += 25

        // Header
        let headers = ["Gerät", "Inv.Nr.", "Zustand"]
        let columnWidths: [CGFloat] = [200, 100, 130]

        y = drawTableHeader(
            in: context,
            headers: headers,
            columnWidths: columnWidths,
            yPosition: y,
            margin: margin
        )

        // Rows with checkbox
        for item in items {
            let row = [
                item.equipment?.displayName ?? "Unbekannt",
                item.equipment?.inventoryNumber ?? "-",
                "☐ OK  ☐ Beschädigt"
            ]

            y = drawTableRow(
                in: context,
                values: row,
                columnWidths: columnWidths,
                yPosition: y,
                margin: margin
            )
        }

        return y
    }

    private static func drawTableHeader(
        in context: CGContext,
        headers: [String],
        columnWidths: [CGFloat],
        yPosition: CGFloat,
        margin: CGFloat
    ) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor: UIColor.darkGray
        ]

        var x = margin
        for (index, header) in headers.enumerated() {
            let headerString = NSAttributedString(string: header, attributes: attributes)
            headerString.draw(at: CGPoint(x: x, y: yPosition))
            x += columnWidths[index]
        }

        // Line
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: margin, y: yPosition + 15))
        context.addLine(to: CGPoint(x: x, y: yPosition + 15))
        context.strokePath()

        return yPosition + 20
    }

    private static func drawTableRow(
        in context: CGContext,
        values: [String],
        columnWidths: [CGFloat],
        yPosition: CGFloat,
        margin: CGFloat
    ) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.black
        ]

        var x = margin
        for (index, value) in values.enumerated() {
            let valueString = NSAttributedString(string: value, attributes: attributes)
            valueString.draw(at: CGPoint(x: x, y: yPosition))
            x += columnWidths[index]
        }

        return yPosition + 18
    }

    private static func drawSignatureFields(
        in context: CGContext,
        yPosition: CGFloat,
        margin: CGFloat,
        pageWidth: CGFloat
    ) {
        let fieldWidth: CGFloat = 200
        let spacing: CGFloat = 50

        let leftX = margin
        let rightX = pageWidth - margin - fieldWidth

        // Labels
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.darkGray
        ]

        let vermieterLabel = NSAttributedString(string: "Vermieter", attributes: attributes)
        vermieterLabel.draw(at: CGPoint(x: leftX, y: yPosition))

        let mieterLabel = NSAttributedString(string: "Mieter", attributes: attributes)
        mieterLabel.draw(at: CGPoint(x: rightX, y: yPosition))

        // Signature Lines
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1)

        // Left line
        context.move(to: CGPoint(x: leftX, y: yPosition + 50))
        context.addLine(to: CGPoint(x: leftX + fieldWidth, y: yPosition + 50))

        // Right line
        context.move(to: CGPoint(x: rightX, y: yPosition + 50))
        context.addLine(to: CGPoint(x: rightX + fieldWidth, y: yPosition + 50))

        context.strokePath()

        // Date/Place Labels
        let datePlaceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.gray
        ]

        let dateLabel = NSAttributedString(string: "Datum, Unterschrift", attributes: datePlaceAttributes)
        dateLabel.draw(at: CGPoint(x: leftX, y: yPosition + 55))
        dateLabel.draw(at: CGPoint(x: rightX, y: yPosition + 55))
    }

    private static func drawFooter(
        in context: CGContext,
        pageRect: CGRect,
        margin: CGFloat
    ) {
        let footerY = pageRect.height - 30

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor.gray
        ]

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "de_DE")

        let footerText = "Erstellt am \(dateFormatter.string(from: Date())) mit MediaTechManager"
        let footerString = NSAttributedString(string: footerText, attributes: attributes)
        footerString.draw(at: CGPoint(x: margin, y: footerY))
    }

    private static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: NSNumber(value: value)) ?? "\(value) €"
    }
}
