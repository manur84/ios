//
//  KeychainManager.swift
//  MediaTechManager
//
//  Sichere Speicherung sensibler Daten in der Keychain
//

import Foundation
import Security

/// Manager für sichere Keychain-Speicherung
final class KeychainManager {

    // MARK: - Singleton

    static let shared = KeychainManager()

    private init() {}

    // MARK: - Errors

    enum KeychainError: LocalizedError {
        case itemNotFound
        case duplicateItem
        case invalidData
        case unhandledError(status: OSStatus)

        var errorDescription: String? {
            switch self {
            case .itemNotFound:
                return "Element nicht gefunden"
            case .duplicateItem:
                return "Element existiert bereits"
            case .invalidData:
                return "Ungültige Daten"
            case .unhandledError(let status):
                return "Keychain Fehler: \(status)"
            }
        }
    }

    // MARK: - Save

    /// Speichert einen String in der Keychain
    func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try save(data, forKey: key)
    }

    /// Speichert Data in der Keychain
    func save(_ data: Data, forKey key: String) throws {
        // Versuche zuerst zu aktualisieren
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Constants.App.bundleIdentifier
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            // Element existiert nicht, neu erstellen
            var newItem = query
            newItem[kSecValueData as String] = data
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

            status = SecItemAdd(newItem as CFDictionary, nil)
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // MARK: - Load

    /// Lädt einen String aus der Keychain
    func loadString(forKey key: String) throws -> String {
        let data = try loadData(forKey: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        return string
    }

    /// Lädt Data aus der Keychain
    func loadData(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Constants.App.bundleIdentifier,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            }
            throw KeychainError.unhandledError(status: status)
        }

        guard let data = result as? Data else {
            throw KeychainError.invalidData
        }

        return data
    }

    // MARK: - Delete

    /// Löscht ein Element aus der Keychain
    func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Constants.App.bundleIdentifier
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // MARK: - Exists

    /// Prüft, ob ein Element existiert
    func exists(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Constants.App.bundleIdentifier,
            kSecReturnData as String: false
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Convenience Methods

    /// Speichert den PIN
    func savePIN(_ pin: String) throws {
        try save(pin, forKey: Constants.KeychainKeys.pinCode)
    }

    /// Lädt den PIN
    func loadPIN() throws -> String {
        try loadString(forKey: Constants.KeychainKeys.pinCode)
    }

    /// Löscht den PIN
    func deletePIN() throws {
        try delete(forKey: Constants.KeychainKeys.pinCode)
    }

    /// Prüft, ob ein PIN gesetzt ist
    var hasPIN: Bool {
        exists(forKey: Constants.KeychainKeys.pinCode)
    }

    /// Validiert den PIN
    func validatePIN(_ pin: String) -> Bool {
        guard let storedPIN = try? loadPIN() else {
            return false
        }
        return storedPIN == pin
    }
}
