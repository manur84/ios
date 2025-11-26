//
//  Constants.swift
//  MediaTechManager
//
//  App-weite Konstanten
//

import Foundation

/// App-weite Konstanten
enum Constants {

    // MARK: - App Info

    enum App {
        /// App Name
        static let name = "MediaTechManager"

        /// Bundle Identifier
        static let bundleIdentifier = "com.mediatech.manager"

        /// App Group (für Widgets)
        static let appGroup = "group.com.mediatech.manager"

        /// Version
        static var version: String {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        }

        /// Build Number
        static var build: String {
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        }

        /// Vollständige Version
        static var fullVersion: String {
            "\(version) (\(build))"
        }
    }

    // MARK: - URLs

    enum URLs {
        /// Support E-Mail
        static let supportEmail = "support@mediatechmanager.app"

        /// Website
        static let website = URL(string: "https://mediatechmanager.app")!

        /// Datenschutzerklärung
        static let privacyPolicy = URL(string: "https://mediatechmanager.app/privacy")!

        /// Nutzungsbedingungen
        static let termsOfService = URL(string: "https://mediatechmanager.app/terms")!

        /// Support
        static let support = URL(string: "https://mediatechmanager.app/support")!
    }

    // MARK: - Limits

    enum Limits {
        /// Maximale Bildgröße in KB
        static let maxImageSizeKB = 500

        /// Maximale Anzahl Bilder pro Gerät
        static let maxImagesPerEquipment = 10

        /// Maximale Länge für Namen
        static let maxNameLength = 100

        /// Maximale Länge für Beschreibungen
        static let maxDescriptionLength = 1000

        /// Maximale Länge für Notizen
        static let maxNotesLength = 5000

        /// Minimale PIN-Länge
        static let minPINLength = 4

        /// Maximale PIN-Länge
        static let maxPINLength = 6

        /// Maximale fehlgeschlagene Anmeldeversuche
        static let maxFailedAuthAttempts = 5

        /// Sperrzeit nach fehlgeschlagenen Versuchen (Sekunden)
        static let authLockoutDuration: TimeInterval = 300
    }

    // MARK: - Storage Keys

    enum StorageKeys {
        /// Onboarding abgeschlossen
        static let onboardingCompleted = "onboardingCompleted"

        /// Sicherheit aktiviert
        static let securityEnabled = "securityEnabled"

        /// Biometrie aktiviert
        static let biometricEnabled = "biometricEnabled"

        /// Auto-Lock aktiviert
        static let autoLockEnabled = "autoLockEnabled"

        /// Auto-Lock Timeout (Sekunden)
        static let autoLockTimeout = "autoLockTimeout"

        /// Dark Mode Einstellung
        static let darkModePreference = "darkModePreference"

        /// Letzte Sync Zeit
        static let lastSyncDate = "lastSyncDate"

        /// Fehlgeschlagene Auth-Versuche
        static let failedAuthAttempts = "failedAuthAttempts"

        /// Letzter fehlgeschlagener Versuch
        static let lastFailedAuthAttempt = "lastFailedAuthAttempt"

        /// Letzte genutzte Inventarnummer
        static let lastInventoryNumber = "lastInventoryNumber"

        /// Letzte genutzte Kundennummer
        static let lastCustomerNumber = "lastCustomerNumber"

        /// Letzte genutzte Ausleihnummer
        static let lastRentalNumber = "lastRentalNumber"
    }

    // MARK: - Keychain Keys

    enum KeychainKeys {
        /// PIN Code
        static let pinCode = "com.mediatech.manager.pin"

        /// Encryption Key
        static let encryptionKey = "com.mediatech.manager.encryption"
    }

    // MARK: - Notification Names

    enum NotificationNames {
        static let authStateChanged = Notification.Name("authStateChanged")
        static let dataChanged = Notification.Name("dataChanged")
        static let syncCompleted = Notification.Name("syncCompleted")
    }

    // MARK: - Date Formats

    enum DateFormats {
        /// Standard Datum (z.B. "24.12.2024")
        static let standard = "dd.MM.yyyy"

        /// Kurzes Datum (z.B. "24.12.")
        static let short = "dd.MM."

        /// Mit Zeit (z.B. "24.12.2024, 14:30")
        static let withTime = "dd.MM.yyyy, HH:mm"

        /// Nur Zeit (z.B. "14:30")
        static let timeOnly = "HH:mm"

        /// ISO Format
        static let iso = "yyyy-MM-dd'T'HH:mm:ssZ"

        /// Dateiname Format
        static let filename = "yyyy-MM-dd_HHmmss"
    }

    // MARK: - QR Code

    enum QRCode {
        /// URL Scheme für Equipment
        static let equipmentScheme = "MTM://equipment/"

        /// URL Scheme für Rental
        static let rentalScheme = "MTM://rental/"

        /// URL Scheme für Customer
        static let customerScheme = "MTM://customer/"

        /// QR Code Größe
        static let defaultSize: CGFloat = 200

        /// QR Code Correction Level
        static let correctionLevel = "M"
    }

    // MARK: - Export

    enum Export {
        /// CSV Trennzeichen
        static let csvSeparator = ";"

        /// CSV Dateierweiterung
        static let csvExtension = "csv"

        /// JSON Dateierweiterung
        static let jsonExtension = "json"

        /// PDF Dateierweiterung
        static let pdfExtension = "pdf"

        /// Backup Dateierweiterung
        static let backupExtension = "mtmbackup"
    }

    // MARK: - Company Info (Platzhalter)

    enum Company {
        static let defaultName = "Mein Unternehmen"
        static let defaultAddress = ""
        static let defaultPhone = ""
        static let defaultEmail = ""
        static let defaultWebsite = ""
        static let defaultTaxId = ""
    }
}
