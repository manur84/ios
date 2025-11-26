//
//  String+Extensions.swift
//  MediaTechManager
//
//  String Extensions
//

import Foundation

extension String {

    // MARK: - Validation

    /// Ist die Zeichenkette leer oder enthält nur Whitespace?
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Ist keine leere Zeichenkette
    var isNotEmpty: Bool {
        !isEmpty
    }

    /// Ist keine leere oder Whitespace-only Zeichenkette
    var isNotBlank: Bool {
        !isBlank
    }

    /// Ist eine gültige E-Mail Adresse
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// Ist eine gültige Telefonnummer (vereinfacht)
    var isValidPhone: Bool {
        let phoneRegex = "^[+]?[0-9\\s\\-()]{6,20}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }

    /// Ist eine gültige Postleitzahl (deutsch)
    var isValidGermanPostalCode: Bool {
        let postalRegex = "^[0-9]{5}$"
        let postalPredicate = NSPredicate(format: "SELF MATCHES %@", postalRegex)
        return postalPredicate.evaluate(with: self)
    }

    // MARK: - Transformations

    /// Entfernt führende und abschließende Whitespace
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Erste Buchstaben jedes Wortes groß
    var titleCased: String {
        self.lowercased().capitalized
    }

    /// Nur Zahlen extrahieren
    var digitsOnly: String {
        filter { $0.isNumber }
    }

    /// Nur Buchstaben extrahieren
    var lettersOnly: String {
        filter { $0.isLetter }
    }

    /// Formatiert als Telefonnummer (vereinfacht)
    var formattedAsPhone: String {
        let digits = digitsOnly
        guard digits.count >= 6 else { return self }

        // Einfache deutsche Formatierung
        if digits.hasPrefix("49") {
            return "+\(digits.prefix(2)) \(digits.dropFirst(2).prefix(3)) \(digits.dropFirst(5))"
        } else if digits.hasPrefix("0") {
            return "\(digits.prefix(4)) \(digits.dropFirst(4))"
        }

        return self
    }

    // MARK: - Truncation

    /// Kürzt den String auf die angegebene Länge
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length - trailing.count)) + trailing
        }
        return self
    }

    // MARK: - Localization

    /// Lokalisierter String
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Lokalisierter String mit Argumenten
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }

    // MARK: - URL

    /// Erstellt eine URL aus dem String
    var asURL: URL? {
        URL(string: self)
    }

    /// URL-encoded String
    var urlEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    // MARK: - Initials

    /// Initialen aus dem Namen extrahieren (max 2 Buchstaben)
    var initials: String {
        let words = self.split(separator: " ")
        let initials = words.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }

    // MARK: - Safe Subscript

    /// Sicherer Zugriff auf Character an Index
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// Sicherer Zugriff auf Substring im Range
    subscript(safe range: Range<Int>) -> String? {
        guard range.lowerBound >= 0 && range.upperBound <= count else { return nil }
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
}

// MARK: - Optional String Extension

extension Optional where Wrapped == String {

    /// Ist nil oder leer
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }

    /// Ist nil oder blank (nur Whitespace)
    var isNilOrBlank: Bool {
        self?.isBlank ?? true
    }

    /// Gibt den Wert oder einen Default-String zurück
    func orEmpty() -> String {
        self ?? ""
    }
}
