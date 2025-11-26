//
//  AppStateManager.swift
//  MediaTechManager
//
//  Zentrale Verwaltung des App-Status
//

import SwiftUI
import Combine

/// Zentrale Verwaltung des App-Status
@MainActor
final class AppStateManager: ObservableObject {

    // MARK: - Published Properties

    /// Onboarding wurde abgeschlossen
    @Published var onboardingCompleted: Bool {
        didSet {
            UserDefaults.standard.set(onboardingCompleted, forKey: Constants.StorageKeys.onboardingCompleted)
        }
    }

    /// App ist gesperrt (benötigt Authentifizierung)
    @Published var isLocked: Bool = false

    /// Sicherheit ist aktiviert
    @Published var securityEnabled: Bool {
        didSet {
            UserDefaults.standard.set(securityEnabled, forKey: Constants.StorageKeys.securityEnabled)
        }
    }

    /// Biometrie ist aktiviert
    @Published var biometricEnabled: Bool {
        didSet {
            UserDefaults.standard.set(biometricEnabled, forKey: Constants.StorageKeys.biometricEnabled)
        }
    }

    /// Auto-Lock ist aktiviert
    @Published var autoLockEnabled: Bool {
        didSet {
            UserDefaults.standard.set(autoLockEnabled, forKey: Constants.StorageKeys.autoLockEnabled)
        }
    }

    /// Auto-Lock Timeout in Sekunden
    @Published var autoLockTimeout: TimeInterval {
        didSet {
            UserDefaults.standard.set(autoLockTimeout, forKey: Constants.StorageKeys.autoLockTimeout)
        }
    }

    /// Dark Mode Einstellung
    @Published var darkModePreference: DarkModePreference {
        didSet {
            UserDefaults.standard.set(darkModePreference.rawValue, forKey: Constants.StorageKeys.darkModePreference)
            applyDarkModePreference()
        }
    }

    /// Aktuelle Tab-Auswahl
    @Published var selectedTab: Tab = .dashboard

    /// Zeigt globale Suche
    @Published var showGlobalSearch: Bool = false

    /// Letzte Hintergrund-Zeit
    @Published var lastBackgroundDate: Date?

    // MARK: - Enums

    enum Tab: Int, CaseIterable {
        case dashboard = 0
        case equipment = 1
        case rentals = 2
        case customers = 3
        case settings = 4

        var title: String {
            switch self {
            case .dashboard: return "Dashboard"
            case .equipment: return "Inventar"
            case .rentals: return "Ausleihen"
            case .customers: return "Kunden"
            case .settings: return "Einstellungen"
            }
        }

        var icon: String {
            switch self {
            case .dashboard: return "square.grid.2x2.fill"
            case .equipment: return "shippingbox.fill"
            case .rentals: return "arrow.left.arrow.right"
            case .customers: return "person.2.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    enum DarkModePreference: String, CaseIterable {
        case system = "System"
        case light = "Hell"
        case dark = "Dunkel"

        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var autoLockTimer: Timer?

    // MARK: - Initializer

    init() {
        // Load from UserDefaults
        self.onboardingCompleted = UserDefaults.standard.bool(forKey: Constants.StorageKeys.onboardingCompleted)
        self.securityEnabled = UserDefaults.standard.bool(forKey: Constants.StorageKeys.securityEnabled)
        self.biometricEnabled = UserDefaults.standard.bool(forKey: Constants.StorageKeys.biometricEnabled)
        self.autoLockEnabled = UserDefaults.standard.bool(forKey: Constants.StorageKeys.autoLockEnabled)
        self.autoLockTimeout = UserDefaults.standard.double(forKey: Constants.StorageKeys.autoLockTimeout)

        if autoLockTimeout == 0 {
            self.autoLockTimeout = 300 // Default: 5 Minuten
        }

        let darkModeRaw = UserDefaults.standard.string(forKey: Constants.StorageKeys.darkModePreference) ?? DarkModePreference.system.rawValue
        self.darkModePreference = DarkModePreference(rawValue: darkModeRaw) ?? .system

        // Initial lock state
        if securityEnabled && KeychainManager.shared.hasPIN {
            isLocked = true
        }

        setupNotifications()
    }

    // MARK: - Setup

    private func setupNotifications() {
        // App wird in den Hintergrund versetzt
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppWillResignActive()
            }
            .store(in: &cancellables)

        // App wird wieder aktiv
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppDidBecomeActive()
            }
            .store(in: &cancellables)
    }

    // MARK: - App Lifecycle

    private func handleAppWillResignActive() {
        lastBackgroundDate = Date()
        Logger.info("App wird in Hintergrund versetzt", category: .general)
    }

    private func handleAppDidBecomeActive() {
        guard securityEnabled && autoLockEnabled else { return }
        guard let lastDate = lastBackgroundDate else { return }

        let elapsed = Date().timeIntervalSince(lastDate)

        if elapsed > autoLockTimeout {
            isLocked = true
            Logger.info("Auto-Lock aktiviert nach \(Int(elapsed)) Sekunden", category: .auth)
        }

        lastBackgroundDate = nil
    }

    // MARK: - Authentication

    /// Entsperrt die App
    func unlock() {
        withAnimation {
            isLocked = false
        }
        Logger.info("App entsperrt", category: .auth)
    }

    /// Sperrt die App
    func lock() {
        guard securityEnabled else { return }
        withAnimation {
            isLocked = true
        }
        Logger.info("App gesperrt", category: .auth)
    }

    // MARK: - Dark Mode

    private func applyDarkModePreference() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        switch darkModePreference {
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }

    // MARK: - Number Generation

    /// Generiert die nächste Inventarnummer
    func nextInventoryNumber(prefix: String = "INV") -> String {
        let key = Constants.StorageKeys.lastInventoryNumber
        let lastNumber = UserDefaults.standard.integer(forKey: key)
        let nextNumber = lastNumber + 1
        UserDefaults.standard.set(nextNumber, forKey: key)
        return String(format: "%@-%05d", prefix, nextNumber)
    }

    /// Generiert die nächste Kundennummer
    func nextCustomerNumber(prefix: String = "KND") -> String {
        let key = Constants.StorageKeys.lastCustomerNumber
        let lastNumber = UserDefaults.standard.integer(forKey: key)
        let nextNumber = lastNumber + 1
        UserDefaults.standard.set(nextNumber, forKey: key)
        return String(format: "%@-%05d", prefix, nextNumber)
    }

    /// Generiert die nächste Ausleihnummer
    func nextRentalNumber(prefix: String = "AUS") -> String {
        let key = Constants.StorageKeys.lastRentalNumber
        let lastNumber = UserDefaults.standard.integer(forKey: key)
        let nextNumber = lastNumber + 1
        UserDefaults.standard.set(nextNumber, forKey: key)

        let dateString = Date().formatted.replacingOccurrences(of: ".", with: "")
        return String(format: "%@-%@-%04d", prefix, dateString, nextNumber)
    }
}
