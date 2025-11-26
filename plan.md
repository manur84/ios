# ================================================================================
# CLAUDE CODE CLI PROMPT - iOS Medientechnik-Verwaltung & Verleih App
# PROFESSIONAL EDITION - 100% APP STORE READY
# ================================================================================
# Verwendung: Kopiere diesen gesamten Text und füge ihn in Claude Code CLI ein
# oder speichere als .md Datei und nutze: claude "$(cat MediaTechManager-Prompt.md)"
# ================================================================================

# Projektauftrag: MediaTechManager - Professionelle iOS App für Medientechnik-Verwaltung

## 🎯 Projektziel

Erstelle eine vollständige, sofort in Xcode buildbare und **100% App Store konforme** iOS-App für professionelle Medientechnik-Verwaltung und Geräteverleih. Die App richtet sich an Veranstaltungstechniker, AV-Abteilungen und Verleiher von Medientechnik.

Das Projekt muss als komplettes Xcode-Projekt mit allen notwendigen Dateien, Assets und Konfigurationen erstellt werden. Nach dem Öffnen in Xcode soll die App ohne weitere Anpassungen auf Simulator und echtem Gerät lauffähig sein.

**WICHTIG:** Die App muss allen Apple Guidelines entsprechen und sofort für den App Store Review einreichbar sein.

---

## 📋 Technische Spezifikationen

### Grundkonfiguration
- **Projektname:** MediaTechManager
- **Bundle Identifier:** com.mediatech.manager
- **Sprache:** Swift 5.9+
- **UI Framework:** SwiftUI (100%)
- **Minimum iOS Version:** 17.0
- **Unterstützte Geräte:** iPhone und iPad (Universal App)
- **Architektur:** MVVM mit Repository Pattern
- **Datenpersistenz:** SwiftData mit CloudKit Sync
- **Lokalisierung:** Deutsch (Primary), Englisch (Secondary)
- **App Store Kategorie:** Business / Productivity

### Verwendete Apple Frameworks (keine externen Dependencies!)
- SwiftUI - User Interface
- SwiftData - Datenpersistenz
- CloudKit - iCloud Synchronisation
- LocalAuthentication - Face ID / Touch ID
- AVFoundation - Kamera, QR/Barcode Scanner
- CoreImage - QR-Code Generierung
- PhotosUI - Bildauswahl (PhotosPicker)
- PDFKit - PDF Erstellung und Anzeige
- UserNotifications - Push/Local Notifications
- WidgetKit - Home Screen Widgets
- AppIntents - Siri Shortcuts
- EventKit - Kalenderintegration
- StoreKit 2 - In-App Purchase
- UniformTypeIdentifiers - Dateiexport
- MessageUI - E-Mail Versand
- Charts - Native SwiftUI Charts
- TipKit - Onboarding Tips

---

# ================================================================================
# 🍎 APP STORE COMPLIANCE - VOLLSTÄNDIGE KONFORMITÄT
# ================================================================================

## App Store Review Guidelines Compliance

### 1. Safety (Guideline 1.x)
```
✅ 1.1 Objectionable Content: App enthält keine anstößigen Inhalte
✅ 1.2 User Generated Content: Nicht zutreffend (nur private Daten)
✅ 1.3 Kids Category: Nicht zutreffend (Business App)
✅ 1.4 Physical Harm: Keine gefährlichen Aktivitäten
✅ 1.5 Developer Information: Vollständige Kontaktdaten in App
✅ 1.6 Data Security: Verschlüsselung für sensible Daten
```

### 2. Performance (Guideline 2.x)
```
✅ 2.1 App Completeness: Vollständig funktionsfähig, keine Platzhalter
✅ 2.2 Beta/Demo: Keine Beta-Hinweise, vollständige Funktionalität
✅ 2.3 Accurate Metadata: Beschreibung entspricht App-Funktionen
✅ 2.4 Hardware Compatibility: Universell für iPhone/iPad
✅ 2.5 Software Requirements: Nur Apple Frameworks
```

### 3. Business (Guideline 3.x)
```
✅ 3.1 Payments: StoreKit 2 für In-App Purchases
✅ 3.1.1 In-App Purchase: Alle digitalen Käufe über Apple
✅ 3.1.2 Subscriptions: Auto-renewable Subscriptions korrekt implementiert
✅ 3.2 Other Business Models: Keine unerlaubten Geschäftsmodelle
```

### 4. Design (Guideline 4.x) - KRITISCH
```
✅ 4.0 Design: Professionelles, natives iOS Design
✅ 4.1 Copycats: Einzigartiges Design, keine Kopien
✅ 4.2 Minimum Functionality: Vollständige, nützliche Funktionalität
✅ 4.3 Spam: Keine doppelten Features, klarer Zweck
✅ 4.4 Extensions: Widgets entsprechen Guidelines
✅ 4.5 Apple Sites: Keine Apple-Marken missbraucht
✅ 4.6 Alternate App Icons: Falls verwendet, korrekt implementiert
✅ 4.7 HTML5 Games: Nicht zutreffend
```

### 5. Legal (Guideline 5.x)
```
✅ 5.1 Privacy: Vollständige Privacy Policy, App Privacy Labels
✅ 5.1.1 Data Collection: Transparente Datenerfassung
✅ 5.1.2 Data Use: Klare Verwendungszwecke
✅ 5.1.3 Health Data: Nicht zutreffend
✅ 5.1.4 Kids: Nicht für Kinder
✅ 5.1.5 Location: Nicht verwendet
✅ 5.2 Intellectual Property: Keine fremden Marken/Inhalte
✅ 5.3 Gaming/Gambling: Nicht zutreffend
✅ 5.4 VPN Apps: Nicht zutreffend
✅ 5.5 Developer Code of Conduct: Eingehalten
```

---

## Privacy & Datenschutz (DSGVO & App Store)

### Privacy Policy Requirements
Erstelle eine vollständige Datenschutzerklärung als In-App View und Web-URL:

```swift
// PrivacyPolicyView.swift
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Vollständige deutsche Datenschutzerklärung
                // Alle erfassten Daten transparent auflisten
                // Speicherdauer, Löschfristen
                // Rechte der Nutzer (Auskunft, Löschung, Export)
                // Kontaktdaten des Verantwortlichen
            }
        }
    }
}
```

### App Privacy Labels (App Store Connect Konfiguration)
Dokumentiere alle Datentypen für App Privacy Labels:

```
DATA NOT COLLECTED:
- Die App sammelt keine Daten, die mit der Identität verknüpft werden

DATA COLLECTED (Linked to User):
- Kontaktinformationen (Kunden): Name, E-Mail, Telefon, Adresse
  → Verwendung: App-Funktionalität
  → Nicht für Tracking verwendet
  
- Fotos oder Videos (Gerätebilder): 
  → Verwendung: App-Funktionalität
  → Lokal + Optional iCloud
  
- Identifiers (Interne IDs):
  → Verwendung: App-Funktionalität

DATA NOT USED FOR TRACKING:
✅ Bestätigung: Keine Daten werden für Tracking verwendet
```

### Datenspeicherung
```swift
// Alle Daten werden gespeichert:
// 1. Lokal auf dem Gerät (SwiftData/Core Data)
// 2. Optional in iCloud (CloudKit) - nur mit Nutzer-Zustimmung
// 3. KEINE externen Server
// 4. KEINE Analytics-Dienste
// 5. KEINE Werbung
```

---

## App Store Metadata vorbereiten

### App Store Beschreibung (Deutsch)
```
KURZBESCHREIBUNG (30 Zeichen):
Medientechnik verwalten

UNTERTITEL (30 Zeichen):
Inventar & Verleih

VOLLSTÄNDIGE BESCHREIBUNG:
MediaTech Manager ist die professionelle Lösung für die Verwaltung Ihrer Medientechnik. Perfekt für Veranstaltungstechniker, AV-Abteilungen, Filmproduktionen und Verleihunternehmen.

INVENTAR VERWALTEN
• Erfassen Sie alle Geräte mit Fotos, Seriennummern und Details
• Organisieren Sie mit Kategorien, Zuständen und Standorten
• Scannen Sie Barcodes für schnelle Erfassung
• Verfolgen Sie Wartungsintervalle und Reparaturen

VERLEIH ORGANISIEREN
• Erstellen Sie Ausleihen mit wenigen Klicks
• Digitale Übergabe- und Rücknahmeprotokolle
• Erfassen Sie Unterschriften direkt auf dem Gerät
• Behalten Sie den Überblick über alle aktiven Vorgänge

QR-CODE SYSTEM
• Generieren Sie QR-Codes für jedes Gerät
• Drucken Sie professionelle Etiketten
• Scannen Sie zur schnellen Identifikation
• Starten Sie Ausleihen direkt per Scan

KUNDENVERWALTUNG
• Speichern Sie alle Kundendaten zentral
• Verfolgen Sie die Ausleihhistorie
• Verwalten Sie Kautionen und Zahlungen

STATISTIKEN & BERICHTE
• Analysieren Sie Auslastung und Umsatz
• Erstellen Sie PDF-Berichte
• Exportieren Sie Daten als CSV

SICHERHEIT
• Schützen Sie Ihre Daten mit Face ID / Touch ID
• PIN-Code als Alternative
• iCloud Sync für mehrere Geräte

FEATURES:
✓ Offline-fähig - funktioniert ohne Internet
✓ iCloud Sync - Daten auf allen Geräten
✓ Dark Mode - augenschonend arbeiten
✓ iPad optimiert - nutzen Sie den großen Bildschirm
✓ Widgets - wichtige Infos auf dem Home Screen
✓ Siri Shortcuts - Sprachsteuerung

Entwickelt in Deutschland. Ihre Daten bleiben auf Ihrem Gerät und optional in Ihrer iCloud.

KEYWORDS (100 Zeichen):
Inventar,Verleih,Medientechnik,AV,Equipment,QR-Code,Vermietung,Geräte,Verwaltung,Inventur

SUPPORT URL:
https://mediatechmanager.app/support

PRIVACY POLICY URL:
https://mediatechmanager.app/privacy

MARKETING URL:
https://mediatechmanager.app
```

### Screenshots Spezifikationen
```
Erforderliche Screenshots (für alle Gerätegrößen):
1. Dashboard mit Übersicht
2. Geräteliste mit Suche
3. Geräte-Detailansicht
4. Neue Ausleihe erstellen
5. QR-Code Scanner
6. Statistiken
7. Dark Mode Ansicht

iPhone Screenshots: 6.7" (1290 x 2796), 6.5" (1284 x 2778), 5.5" (1242 x 2208)
iPad Screenshots: 12.9" (2048 x 2732)
```

---

## In-App Purchase Konfiguration (StoreKit 2)

### Subscription Tiers
```swift
enum SubscriptionTier: String, CaseIterable {
    case free = "com.mediatech.manager.free"
    case pro = "com.mediatech.manager.pro.monthly"
    case proYearly = "com.mediatech.manager.pro.yearly"
    case business = "com.mediatech.manager.business.monthly"
    
    var displayName: String {
        switch self {
        case .free: return "Kostenlos"
        case .pro: return "Pro (Monatlich)"
        case .proYearly: return "Pro (Jährlich)"
        case .business: return "Business"
        }
    }
    
    var features: [String] {
        switch self {
        case .free:
            return [
                "Bis zu 20 Geräte",
                "Bis zu 5 Kunden",
                "QR-Code Scanner",
                "Grundlegende Statistiken"
            ]
        case .pro, .proYearly:
            return [
                "Unbegrenzte Geräte",
                "Unbegrenzte Kunden",
                "iCloud Sync",
                "PDF Export",
                "Erweiterte Statistiken",
                "Widgets",
                "Prioritäts-Support"
            ]
        case .business:
            return [
                "Alle Pro Features",
                "Multi-User (in Planung)",
                "API Zugang (in Planung)",
                "Dedizierter Support"
            ]
        }
    }
}

// StoreKit 2 Implementation
@MainActor
class StoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []
    @Published var subscriptionStatus: SubscriptionTier = .free
    
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    func loadProducts() async {
        do {
            let productIds = SubscriptionTier.allCases.map { $0.rawValue }
            products = try await Product.products(for: Set(productIds))
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await updateSubscriptionStatus()
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func updateSubscriptionStatus() async {
        var hasProSubscription = false
        var hasBusinessSubscription = false
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            
            if transaction.productID.contains("business") {
                hasBusinessSubscription = true
            } else if transaction.productID.contains("pro") {
                hasProSubscription = true
            }
        }
        
        if hasBusinessSubscription {
            subscriptionStatus = .business
        } else if hasProSubscription {
            subscriptionStatus = .pro
        } else {
            subscriptionStatus = .free
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
```

### Subscription View (App Store konform)
```swift
struct SubscriptionView: View {
    @StateObject private var storeManager = StoreManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Current Plan
                    currentPlanSection
                    
                    // Feature Comparison
                    featureComparisonSection
                    
                    // Subscription Options
                    subscriptionOptionsSection
                    
                    // Restore Purchases
                    restoreButton
                    
                    // Legal Links (PFLICHT!)
                    legalLinksSection
                }
                .padding()
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
    }
    
    // PFLICHT: Links zu Nutzungsbedingungen
    private var legalLinksSection: some View {
        VStack(spacing: 8) {
            Text("Das Abonnement verlängert sich automatisch, sofern es nicht mindestens 24 Stunden vor Ende der aktuellen Laufzeit gekündigt wird.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Link("Nutzungsbedingungen", destination: URL(string: "https://mediatechmanager.app/terms")!)
                Link("Datenschutz", destination: URL(string: "https://mediatechmanager.app/privacy")!)
            }
            .font(.caption)
        }
        .padding(.top)
    }
}
```

---

# ================================================================================
# 🎨 PROFESSIONELLES UI/UX DESIGN
# ================================================================================

## Design System

### Farbpalette (Color Assets)
```swift
// Colors.swift - Zentrale Farbdefinitionen
extension Color {
    // Primary Brand Colors
    static let brandPrimary = Color("BrandPrimary")       // #007AFF (Apple Blue)
    static let brandSecondary = Color("BrandSecondary")   // #5856D6 (Purple)
    static let brandAccent = Color("BrandAccent")         // #FF9500 (Orange)
    
    // Semantic Colors
    static let success = Color("Success")                  // #34C759
    static let warning = Color("Warning")                  // #FF9500
    static let error = Color("Error")                      // #FF3B30
    static let info = Color("Info")                        // #5AC8FA
    
    // Status Colors (für Ausleihen)
    static let statusReserved = Color("StatusReserved")   // #007AFF
    static let statusActive = Color("StatusActive")       // #34C759
    static let statusOverdue = Color("StatusOverdue")     // #FF3B30
    static let statusReturned = Color("StatusReturned")   // #8E8E93
    
    // Background Colors
    static let backgroundPrimary = Color("BackgroundPrimary")
    static let backgroundSecondary = Color("BackgroundSecondary")
    static let backgroundTertiary = Color("BackgroundTertiary")
    
    // Text Colors
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textTertiary = Color("TextTertiary")
}

// Assets.xcassets Struktur:
// Colors/
//   ├── BrandPrimary.colorset/     (Light: #007AFF, Dark: #0A84FF)
//   ├── BrandSecondary.colorset/   (Light: #5856D6, Dark: #5E5CE6)
//   ├── Success.colorset/          (Light: #34C759, Dark: #30D158)
//   ├── Warning.colorset/          (Light: #FF9500, Dark: #FF9F0A)
//   ├── Error.colorset/            (Light: #FF3B30, Dark: #FF453A)
//   ├── BackgroundPrimary.colorset/ (Light: #FFFFFF, Dark: #000000)
//   ├── BackgroundSecondary.colorset/ (Light: #F2F2F7, Dark: #1C1C1E)
//   └── BackgroundTertiary.colorset/ (Light: #FFFFFF, Dark: #2C2C2E)
```

### Typografie
```swift
// Typography.swift
extension Font {
    // Headlines
    static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 22, weight: .bold, design: .rounded)
    
    // Titles
    static let titleLarge = Font.system(size: 20, weight: .semibold)
    static let titleMedium = Font.system(size: 17, weight: .semibold)
    static let titleSmall = Font.system(size: 15, weight: .semibold)
    
    // Body
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)
    
    // Labels
    static let labelLarge = Font.system(size: 15, weight: .medium)
    static let labelMedium = Font.system(size: 13, weight: .medium)
    static let labelSmall = Font.system(size: 11, weight: .medium)
    
    // Monospace (für IDs, Nummern)
    static let monoLarge = Font.system(size: 17, weight: .medium, design: .monospaced)
    static let monoMedium = Font.system(size: 15, weight: .medium, design: .monospaced)
    static let monoSmall = Font.system(size: 13, weight: .medium, design: .monospaced)
}
```

### Spacing & Layout
```swift
// Spacing.swift
enum Spacing {
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
    
    // Specific Use Cases
    static let cardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let listItemSpacing: CGFloat = 12
    static let iconTextSpacing: CGFloat = 8
}

// Layout.swift
enum Layout {
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadiusXL: CGFloat = 20
    
    static let borderWidth: CGFloat = 1
    static let borderWidthThick: CGFloat = 2
    
    static let shadowRadius: CGFloat = 8
    static let shadowOpacity: CGFloat = 0.1
    
    static let minTouchTarget: CGFloat = 44  // Apple HIG Minimum
    
    static let maxContentWidth: CGFloat = 700  // Für iPad
}
```

### Animationen
```swift
// Animations.swift
extension Animation {
    static let quick = Animation.easeInOut(duration: 0.2)
    static let standard = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.easeInOut(duration: 0.4)
    static let slow = Animation.easeInOut(duration: 0.5)
    
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    
    // Specific Animations
    static let cardAppear = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let modalPresent = Animation.spring(response: 0.4, dampingFraction: 0.85)
    static let buttonPress = Animation.easeInOut(duration: 0.15)
}
```

---

## UI Komponenten (Wiederverwendbar)

### Primary Button
```swift
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(.titleMedium)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isEnabled ? Color.brandPrimary : Color.gray.opacity(0.3))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        }
        .disabled(isLoading)
        .animation(.buttonPress, value: isEnabled)
    }
}

// Usage:
// PrimaryButton("Speichern", icon: "checkmark") { save() }
// PrimaryButton("Laden", isLoading: true) { }
```

### Secondary Button
```swift
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let destructive: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String? = nil,
        destructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.destructive = destructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.iconTextSpacing) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.titleSmall)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.backgroundSecondary)
            .foregroundStyle(destructive ? Color.error : Color.brandPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium)
                    .stroke(destructive ? Color.error.opacity(0.3) : Color.brandPrimary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
```

### Info Card
```swift
struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(Color.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Usage:
// InfoCard {
//     Label("Kamera", systemImage: "camera")
//     Text("Canon EOS R5")
// }
```

### Stat Card (für Dashboard)
```swift
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: Trend?
    
    enum Trend {
        case up(String)
        case down(String)
        case neutral
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
                
                if let trend {
                    trendBadge(trend)
                }
            }
            
            Text(value)
                .font(.displayMedium)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.bodySmall)
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }
    
    @ViewBuilder
    private func trendBadge(_ trend: Trend) -> some View {
        switch trend {
        case .up(let value):
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.right")
                Text(value)
            }
            .font(.labelSmall)
            .foregroundStyle(.success)
        case .down(let value):
            HStack(spacing: 2) {
                Image(systemName: "arrow.down.right")
                Text(value)
            }
            .font(.labelSmall)
            .foregroundStyle(.error)
        case .neutral:
            EmptyView()
        }
    }
}
```

### Status Badge
```swift
struct StatusBadge: View {
    let status: RentalStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.labelMedium)
                .foregroundStyle(status.color)
        }
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, Spacing.xxs)
        .background(status.color.opacity(0.15))
        .clipShape(Capsule())
    }
}

extension RentalStatus {
    var color: Color {
        switch self {
        case .reserved: return .statusReserved
        case .active: return .statusActive
        case .overdue: return .statusOverdue
        case .returned: return .statusReturned
        case .cancelled: return .gray
        }
    }
}
```

### Equipment Row (Listenansicht)
```swift
struct EquipmentRow: View {
    let equipment: Equipment
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Thumbnail
            equipmentImage
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.name)
                    .font(.titleMedium)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text("\(equipment.manufacturer) \(equipment.model)")
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: Spacing.xs) {
                    if let category = equipment.category {
                        CategoryBadge(category: category, size: .small)
                    }
                    
                    if let condition = equipment.condition {
                        ConditionBadge(condition: condition, size: .small)
                    }
                }
            }
            
            Spacer()
            
            // Status & Chevron
            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                availabilityIndicator
                
                if let price = equipment.dailyRate {
                    Text(price.formatted(.currency(code: "EUR")) + "/Tag")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var equipmentImage: some View {
        if let imageData = equipment.images.first,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
        } else {
            RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall)
                .fill(Color.backgroundSecondary)
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.tertiary)
                }
        }
    }
    
    @ViewBuilder
    private var availabilityIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(equipment.isAvailable ? Color.success : Color.warning)
                .frame(width: 8, height: 8)
            
            Text(equipment.isAvailable ? "Verfügbar" : "Verliehen")
                .font(.labelSmall)
                .foregroundStyle(equipment.isAvailable ? .success : .warning)
        }
    }
}
```

### Empty State View
```swift
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(.tertiary)
            
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(.titleLarge)
                    .foregroundStyle(.primary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
            }
            
            if let actionTitle, let action {
                Button(action: action) {
                    Label(actionTitle, systemImage: "plus")
                        .font(.titleSmall)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, Spacing.sm)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Usage:
// EmptyStateView(
//     icon: "shippingbox",
//     title: "Keine Geräte",
//     message: "Fügen Sie Ihr erstes Gerät hinzu, um loszulegen.",
//     actionTitle: "Gerät hinzufügen"
// ) { showAddEquipment = true }
```

### Loading Overlay
```swift
struct LoadingOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.md) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundStyle(.white)
            }
            .padding(Spacing.xl)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
        }
    }
}

// Usage as ViewModifier:
extension View {
    func loadingOverlay(isLoading: Bool, message: String = "Laden...") -> some View {
        ZStack {
            self
            
            if isLoading {
                LoadingOverlay(message: message)
            }
        }
    }
}
```

### Toast Notification
```swift
struct ToastView: View {
    let message: String
    let type: ToastType
    
    enum ToastType {
        case success, error, info, warning
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .success: return .success
            case .error: return .error
            case .info: return .info
            case .warning: return .warning
            }
        }
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: type.icon)
                .foregroundStyle(type.color)
            
            Text(message)
                .font(.bodyMedium)
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, Spacing.md)
    }
}

// Toast Manager
@Observable
class ToastManager {
    var currentToast: (message: String, type: ToastView.ToastType)?
    
    func show(_ message: String, type: ToastView.ToastType = .info) {
        withAnimation(.spring) {
            currentToast = (message, type)
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            withAnimation(.spring) {
                currentToast = nil
            }
        }
    }
}
```

### Search Bar
```swift
struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    var onSubmit: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
    }
}
```

---

## Professionelle View-Layouts

### Dashboard View
```swift
struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var equipment: [Equipment]
    @Query private var rentals: [Rental]
    @Query private var customers: [Customer]
    
    @State private var showNewEquipment = false
    @State private var showNewRental = false
    @State private var showScanner = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.sectionSpacing) {
                    // Quick Stats Grid
                    statsSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Overdue Rentals (if any)
                    if !overdueRentals.isEmpty {
                        overdueSection
                    }
                    
                    // Upcoming Returns
                    upcomingReturnsSection
                    
                    // Recent Activity
                    recentActivitySection
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            showNewEquipment = true
                        } label: {
                            Label("Neues Gerät", systemImage: "plus.circle")
                        }
                        
                        Button {
                            showNewRental = true
                        } label: {
                            Label("Neue Ausleihe", systemImage: "arrow.right.circle")
                        }
                        
                        Button {
                            showScanner = true
                        } label: {
                            Label("QR-Code scannen", systemImage: "qrcode.viewfinder")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showNewEquipment) {
                EquipmentEditView(equipment: nil)
            }
            .sheet(isPresented: $showNewRental) {
                NewRentalView()
            }
            .fullScreenCover(isPresented: $showScanner) {
                QRCodeScannerView()
            }
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: Spacing.md) {
            StatCard(
                title: "Geräte gesamt",
                value: "\(equipment.count)",
                icon: "shippingbox.fill",
                color: .brandPrimary,
                trend: nil
            )
            
            StatCard(
                title: "Verfügbar",
                value: "\(availableCount)",
                icon: "checkmark.circle.fill",
                color: .success,
                trend: nil
            )
            
            StatCard(
                title: "Ausgeliehen",
                value: "\(rentedCount)",
                icon: "arrow.right.circle.fill",
                color: .warning,
                trend: nil
            )
            
            StatCard(
                title: "Überfällig",
                value: "\(overdueRentals.count)",
                icon: "exclamationmark.triangle.fill",
                color: overdueRentals.isEmpty ? .gray : .error,
                trend: nil
            )
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Schnellaktionen")
                .font(.titleMedium)
                .foregroundStyle(.primary)
            
            HStack(spacing: Spacing.md) {
                QuickActionButton(
                    title: "Scannen",
                    icon: "qrcode.viewfinder",
                    color: .brandPrimary
                ) {
                    showScanner = true
                }
                
                QuickActionButton(
                    title: "Ausleihen",
                    icon: "arrow.right.circle",
                    color: .success
                ) {
                    showNewRental = true
                }
                
                QuickActionButton(
                    title: "Hinzufügen",
                    icon: "plus.circle",
                    color: .brandSecondary
                ) {
                    showNewEquipment = true
                }
            }
        }
    }
    
    // MARK: - Overdue Section
    private var overdueSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.error)
                Text("Überfällige Ausleihen")
                    .font(.titleMedium)
                Spacer()
                Text("\(overdueRentals.count)")
                    .font(.titleSmall)
                    .foregroundStyle(.error)
            }
            
            ForEach(overdueRentals.prefix(3)) { rental in
                OverdueRentalRow(rental: rental)
            }
            
            if overdueRentals.count > 3 {
                NavigationLink("Alle anzeigen") {
                    RentalListView(filter: .overdue)
                }
                .font(.bodySmall)
            }
        }
        .padding(Spacing.cardPadding)
        .background(Color.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }
    
    // MARK: - Computed Properties
    private var availableCount: Int {
        equipment.filter { $0.isAvailable }.count
    }
    
    private var rentedCount: Int {
        equipment.filter { !$0.isAvailable }.count
    }
    
    private var overdueRentals: [Rental] {
        rentals.filter { $0.status == .overdue }
    }
}

// Quick Action Button Component
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.labelMedium)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        }
        .buttonStyle(.plain)
    }
}
```

### Equipment List View
```swift
struct EquipmentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Equipment.name) private var allEquipment: [Equipment]
    
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var selectedCondition: Condition?
    @State private var showAvailableOnly = false
    @State private var sortOption: SortOption = .name
    @State private var showFilters = false
    @State private var showAddEquipment = false
    @State private var viewMode: ViewMode = .list
    
    enum ViewMode {
        case list, grid
    }
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case date = "Datum"
        case category = "Kategorie"
        case inventoryNumber = "Inventarnr."
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredEquipment.isEmpty {
                    emptyState
                } else {
                    equipmentList
                }
            }
            .navigationTitle("Inventar")
            .searchable(text: $searchText, prompt: "Suchen...")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu {
                        Picker("Sortieren", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    Button {
                        withAnimation {
                            viewMode = viewMode == .list ? .grid : .list
                        }
                    } label: {
                        Image(systemName: viewMode == .list ? "square.grid.2x2" : "list.bullet")
                    }
                    
                    Button {
                        showAddEquipment = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                EquipmentFilterView(
                    selectedCategory: $selectedCategory,
                    selectedCondition: $selectedCondition,
                    showAvailableOnly: $showAvailableOnly
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAddEquipment) {
                EquipmentEditView(equipment: nil)
            }
        }
    }
    
    // MARK: - Equipment List
    @ViewBuilder
    private var equipmentList: some View {
        switch viewMode {
        case .list:
            List {
                ForEach(filteredEquipment) { equipment in
                    NavigationLink(value: equipment) {
                        EquipmentRow(equipment: equipment)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteEquipment(equipment)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        if equipment.isAvailable {
                            Button {
                                // Start rental
                            } label: {
                                Label("Ausleihen", systemImage: "arrow.right")
                            }
                            .tint(.success)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Equipment.self) { equipment in
                EquipmentDetailView(equipment: equipment)
            }
            
        case .grid:
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 160), spacing: Spacing.md)
                ], spacing: Spacing.md) {
                    ForEach(filteredEquipment) { equipment in
                        NavigationLink(value: equipment) {
                            EquipmentGridCard(equipment: equipment)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.md)
            }
            .navigationDestination(for: Equipment.self) { equipment in
                EquipmentDetailView(equipment: equipment)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        EmptyStateView(
            icon: "shippingbox",
            title: searchText.isEmpty ? "Keine Geräte" : "Keine Ergebnisse",
            message: searchText.isEmpty 
                ? "Fügen Sie Ihr erstes Gerät hinzu, um mit der Inventarisierung zu beginnen."
                : "Keine Geräte gefunden für \"\(searchText)\"",
            actionTitle: searchText.isEmpty ? "Gerät hinzufügen" : nil
        ) {
            showAddEquipment = true
        }
    }
    
    // MARK: - Filtering
    private var filteredEquipment: [Equipment] {
        var result = allEquipment
        
        // Search
        if !searchText.isEmpty {
            result = result.filter { equipment in
                equipment.name.localizedCaseInsensitiveContains(searchText) ||
                equipment.manufacturer.localizedCaseInsensitiveContains(searchText) ||
                equipment.model.localizedCaseInsensitiveContains(searchText) ||
                equipment.inventoryNumber.localizedCaseInsensitiveContains(searchText) ||
                equipment.serialNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Category Filter
        if let category = selectedCategory {
            result = result.filter { $0.category?.id == category.id }
        }
        
        // Condition Filter
        if let condition = selectedCondition {
            result = result.filter { $0.condition?.id == condition.id }
        }
        
        // Availability Filter
        if showAvailableOnly {
            result = result.filter { $0.isAvailable }
        }
        
        // Sorting
        switch sortOption {
        case .name:
            result.sort { $0.name < $1.name }
        case .date:
            result.sort { $0.createdAt > $1.createdAt }
        case .category:
            result.sort { ($0.category?.name ?? "") < ($1.category?.name ?? "") }
        case .inventoryNumber:
            result.sort { $0.inventoryNumber < $1.inventoryNumber }
        }
        
        return result
    }
    
    private var hasActiveFilters: Bool {
        selectedCategory != nil || selectedCondition != nil || showAvailableOnly
    }
    
    private func deleteEquipment(_ equipment: Equipment) {
        modelContext.delete(equipment)
    }
}

// Grid Card for Equipment
struct EquipmentGridCard: View {
    let equipment: Equipment
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Image
            equipmentImage
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(equipment.name)
                    .font(.titleSmall)
                    .lineLimit(1)
                
                Text(equipment.manufacturer)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Circle()
                        .fill(equipment.isAvailable ? Color.success : Color.warning)
                        .frame(width: 6, height: 6)
                    
                    Text(equipment.isAvailable ? "Verfügbar" : "Verliehen")
                        .font(.labelSmall)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
    }
    
    @ViewBuilder
    private var equipmentImage: some View {
        if let imageData = equipment.images.first,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Rectangle()
                .fill(Color.backgroundSecondary)
                .overlay {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.tertiary)
                }
        }
    }
}
```

---

## Accessibility (WCAG & Apple Guidelines)

### Vollständige VoiceOver Unterstützung
```swift
// Alle interaktiven Elemente müssen Labels haben
struct AccessibleEquipmentRow: View {
    let equipment: Equipment
    
    var body: some View {
        HStack {
            // ... content
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityHint("Doppeltippen für Details")
        .accessibilityAddTraits(.isButton)
    }
    
    private var accessibilityDescription: String {
        var description = equipment.name
        description += ", \(equipment.manufacturer) \(equipment.model)"
        description += ", \(equipment.isAvailable ? "verfügbar" : "ausgeliehen")"
        if let category = equipment.category {
            description += ", Kategorie: \(category.name)"
        }
        return description
    }
}

// Custom Accessibility Actions
struct AccessibleRentalRow: View {
    let rental: Rental
    
    var body: some View {
        HStack {
            // ... content
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityActions {
            Button("Anrufen") { callCustomer() }
            Button("Verlängern") { extendRental() }
            if rental.status == .active {
                Button("Rücknahme starten") { startReturn() }
            }
        }
    }
}
```

### Dynamic Type Support
```swift
// Alle Texte müssen Dynamic Type unterstützen
struct DynamicTypeText: View {
    let text: String
    let style: Font.TextStyle
    
    var body: some View {
        Text(text)
            .font(.system(style))
            .dynamicTypeSize(...DynamicTypeSize.accessibility3) // Limit für Layout
            .lineLimit(nil) // Text kann umbrechen
    }
}

// Layout anpassen für große Schriften
struct AdaptiveLayout: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        if dynamicTypeSize >= .accessibility1 {
            // Vertikales Layout für große Schriften
            VStack(alignment: .leading) {
                content
            }
        } else {
            // Horizontales Layout für normale Schriften
            HStack {
                content
            }
        }
    }
}
```

### Farbenblindheit berücksichtigen
```swift
// Nie nur Farbe für Bedeutung verwenden
struct AccessibleStatusBadge: View {
    let status: RentalStatus
    
    var body: some View {
        HStack(spacing: 4) {
            // Icon zusätzlich zur Farbe
            Image(systemName: status.icon)
                .font(.system(size: 10))
            
            // Text zusätzlich zur Farbe
            Text(status.rawValue)
                .font(.labelSmall)
        }
        .foregroundStyle(status.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.15))
        .clipShape(Capsule())
    }
}
```

### Reduzierte Bewegung
```swift
// Animation nur wenn gewünscht
struct AnimatedCard: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isVisible = false
    
    var body: some View {
        CardContent()
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : (reduceMotion ? 0 : 20))
            .animation(reduceMotion ? nil : .spring, value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}
```

---

## Performance Optimierung

### Lazy Loading für Listen
```swift
struct OptimizedEquipmentList: View {
    @Query private var equipment: [Equipment]
    
    var body: some View {
        List {
            // LazyVStack für bessere Performance
            LazyVStack(spacing: 0) {
                ForEach(equipment) { item in
                    EquipmentRow(equipment: item)
                        .id(item.id) // Stabile IDs für Recycling
                }
            }
        }
        .listStyle(.plain)
    }
}
```

### Bilder komprimieren und cachen
```swift
// ImageService.swift
actor ImageService {
    static let shared = ImageService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func compressImage(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > maxSizeKB * 1024, compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    func thumbnail(for data: Data, size: CGSize) async -> UIImage? {
        let cacheKey = NSString(string: "\(data.hashValue)-\(size.width)x\(size.height)")
        
        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }
        
        guard let image = UIImage(data: data) else { return nil }
        
        let thumbnail = await image.byPreparingThumbnail(ofSize: size)
        
        if let thumbnail {
            cache.setObject(thumbnail, forKey: cacheKey)
        }
        
        return thumbnail
    }
}
```

### Effiziente SwiftData Queries
```swift
// Nur benötigte Daten laden
struct OptimizedDashboard: View {
    // Nur Counts abfragen, nicht alle Objekte
    @Query(filter: #Predicate<Equipment> { $0.isAvailable })
    private var availableEquipment: [Equipment]
    
    @Query(filter: #Predicate<Rental> { $0.status == .overdue })
    private var overdueRentals: [Rental]
    
    // Sortierung und Limit
    @Query(
        filter: #Predicate<Rental> { $0.status == .active },
        sort: \Rental.plannedEndDate,
        order: .forward
    )
    private var upcomingReturns: [Rental]
    
    var body: some View {
        // Nur first 5 anzeigen
        ForEach(upcomingReturns.prefix(5)) { rental in
            RentalRow(rental: rental)
        }
    }
}
```

---

## Testing Requirements

### Unit Tests
```swift
// EquipmentTests.swift
import Testing
@testable import MediaTechManager

@Suite("Equipment Tests")
struct EquipmentTests {
    
    @Test("Equipment Initialization")
    func testEquipmentInitialization() {
        let equipment = Equipment(
            name: "Test Camera",
            manufacturer: "Canon",
            model: "EOS R5"
        )
        
        #expect(equipment.name == "Test Camera")
        #expect(equipment.isAvailable == true)
        #expect(equipment.isActive == true)
        #expect(equipment.id != nil)
    }
    
    @Test("Equipment Availability")
    func testEquipmentAvailability() {
        let equipment = Equipment(name: "Test")
        equipment.isAvailable = false
        
        #expect(equipment.isAvailable == false)
    }
}
```

### UI Tests
```swift
// EquipmentUITests.swift
import XCTest

final class EquipmentUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testAddEquipment() throws {
        // Navigate to Equipment
        app.tabBars["Tab Bar"].buttons["Inventar"].tap()
        
        // Tap add button
        app.navigationBars.buttons["plus"].tap()
        
        // Fill form
        let nameField = app.textFields["Name"]
        nameField.tap()
        nameField.typeText("Test Kamera")
        
        // Save
        app.buttons["Speichern"].tap()
        
        // Verify
        XCTAssertTrue(app.staticTexts["Test Kamera"].exists)
    }
    
    func testSearchEquipment() throws {
        app.tabBars["Tab Bar"].buttons["Inventar"].tap()
        
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Canon")
        
        // Verify results update
        XCTAssertTrue(app.cells.count > 0)
    }
}
```

---

## 📁 Vollständige Projektstruktur

```
MediaTechManager/
├── MediaTechManager.xcodeproj/
│   └── project.pbxproj
├── MediaTechManager/
│   ├── App/
│   │   ├── MediaTechManagerApp.swift
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   │
│   ├── Core/
│   │   ├── DesignSystem/
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   ├── Spacing.swift
│   │   │   ├── Layout.swift
│   │   │   └── Animations.swift
│   │   ├── Extensions/
│   │   │   ├── Date+Extensions.swift
│   │   │   ├── String+Extensions.swift
│   │   │   ├── Color+Extensions.swift
│   │   │   ├── View+Extensions.swift
│   │   │   ├── Image+Extensions.swift
│   │   │   ├── Double+Currency.swift
│   │   │   ├── Array+Extensions.swift
│   │   │   └── UIImage+Compression.swift
│   │   ├── Utilities/
│   │   │   ├── Constants.swift
│   │   │   ├── Formatters.swift
│   │   │   ├── Validators.swift
│   │   │   ├── KeychainManager.swift
│   │   │   ├── HapticManager.swift
│   │   │   ├── SoundManager.swift
│   │   │   └── Logger.swift
│   │   └── Modifiers/
│   │       ├── CardStyle.swift
│   │       ├── PrimaryButtonStyle.swift
│   │       ├── SecondaryButtonStyle.swift
│   │       ├── ShakeEffect.swift
│   │       └── ConditionalModifier.swift
│   │
│   ├── Models/
│   │   ├── Core/
│   │   │   ├── Equipment.swift
│   │   │   ├── Customer.swift
│   │   │   ├── Rental.swift
│   │   │   ├── Category.swift
│   │   │   ├── Condition.swift
│   │   │   ├── Location.swift
│   │   │   └── Tag.swift
│   │   ├── Supporting/
│   │   │   ├── MaintenanceRecord.swift
│   │   │   ├── DamageReport.swift
│   │   │   ├── Document.swift
│   │   │   ├── Signature.swift
│   │   │   ├── AuditLog.swift
│   │   │   ├── CustomField.swift
│   │   │   └── AppSettings.swift
│   │   └── Enums/
│   │       ├── RentalStatus.swift
│   │       ├── MaintenanceType.swift
│   │       ├── DamageType.swift
│   │       ├── ExportFormat.swift
│   │       └── AuthenticationType.swift
│   │
│   ├── ViewModels/
│   │   ├── EquipmentViewModel.swift
│   │   ├── RentalViewModel.swift
│   │   ├── CustomerViewModel.swift
│   │   ├── MaintenanceViewModel.swift
│   │   ├── StatisticsViewModel.swift
│   │   ├── AuthenticationViewModel.swift
│   │   ├── SettingsViewModel.swift
│   │   ├── SearchViewModel.swift
│   │   ├── CalendarViewModel.swift
│   │   └── DashboardViewModel.swift
│   │
│   ├── Views/
│   │   ├── Main/
│   │   │   ├── ContentView.swift
│   │   │   ├── MainTabView.swift
│   │   │   ├── DashboardView.swift
│   │   │   └── SplashScreenView.swift
│   │   │
│   │   ├── Equipment/
│   │   │   ├── EquipmentListView.swift
│   │   │   ├── EquipmentDetailView.swift
│   │   │   ├── EquipmentEditView.swift
│   │   │   ├── EquipmentRow.swift
│   │   │   ├── EquipmentGridCard.swift
│   │   │   ├── EquipmentFilterView.swift
│   │   │   ├── EquipmentHistoryView.swift
│   │   │   ├── EquipmentGalleryView.swift
│   │   │   └── EquipmentImportView.swift
│   │   │
│   │   ├── Rental/
│   │   │   ├── RentalListView.swift
│   │   │   ├── RentalDetailView.swift
│   │   │   ├── NewRentalView.swift
│   │   │   ├── RentalRow.swift
│   │   │   ├── RentalCalendarView.swift
│   │   │   ├── HandoverProtocolView.swift
│   │   │   ├── ReturnProtocolView.swift
│   │   │   ├── SignatureCaptureView.swift
│   │   │   └── RentalExtensionView.swift
│   │   │
│   │   ├── Customer/
│   │   │   ├── CustomerListView.swift
│   │   │   ├── CustomerDetailView.swift
│   │   │   ├── CustomerEditView.swift
│   │   │   ├── CustomerRow.swift
│   │   │   └── CustomerHistoryView.swift
│   │   │
│   │   ├── QRCode/
│   │   │   ├── QRCodeGeneratorView.swift
│   │   │   ├── QRCodeScannerView.swift
│   │   │   ├── BarcodeScannerView.swift
│   │   │   ├── QRCodePrintView.swift
│   │   │   ├── QRCodeBatchPrintView.swift
│   │   │   ├── LabelDesignerView.swift
│   │   │   └── ScanResultView.swift
│   │   │
│   │   ├── Maintenance/
│   │   │   ├── MaintenanceListView.swift
│   │   │   ├── MaintenanceDetailView.swift
│   │   │   ├── MaintenanceScheduleView.swift
│   │   │   ├── NewMaintenanceView.swift
│   │   │   └── MaintenanceCalendarView.swift
│   │   │
│   │   ├── Damage/
│   │   │   ├── DamageReportListView.swift
│   │   │   ├── DamageReportDetailView.swift
│   │   │   ├── NewDamageReportView.swift
│   │   │   └── DamagePhotoView.swift
│   │   │
│   │   ├── Statistics/
│   │   │   ├── StatisticsOverviewView.swift
│   │   │   ├── EquipmentStatsView.swift
│   │   │   ├── RentalStatsView.swift
│   │   │   ├── RevenueStatsView.swift
│   │   │   ├── CustomerStatsView.swift
│   │   │   ├── ChartViews/
│   │   │   │   ├── BarChartView.swift
│   │   │   │   ├── LineChartView.swift
│   │   │   │   ├── PieChartView.swift
│   │   │   │   └── TrendChartView.swift
│   │   │   └── ReportGeneratorView.swift
│   │   │
│   │   ├── Calendar/
│   │   │   ├── CalendarOverviewView.swift
│   │   │   ├── DayDetailView.swift
│   │   │   ├── WeekOverviewView.swift
│   │   │   └── TimelineView.swift
│   │   │
│   │   ├── Settings/
│   │   │   ├── SettingsView.swift
│   │   │   ├── CategoryManagementView.swift
│   │   │   ├── ConditionManagementView.swift
│   │   │   ├── LocationManagementView.swift
│   │   │   ├── TagManagementView.swift
│   │   │   ├── CustomFieldsManagementView.swift
│   │   │   ├── SecuritySettingsView.swift
│   │   │   ├── NotificationSettingsView.swift
│   │   │   ├── CloudSyncSettingsView.swift
│   │   │   ├── ExportImportView.swift
│   │   │   ├── BackupRestoreView.swift
│   │   │   ├── AppearanceSettingsView.swift
│   │   │   ├── CompanyInfoView.swift
│   │   │   ├── PricingSettingsView.swift
│   │   │   ├── SubscriptionView.swift
│   │   │   ├── PrivacyPolicyView.swift
│   │   │   ├── TermsOfServiceView.swift
│   │   │   ├── AuditLogView.swift
│   │   │   └── AboutView.swift
│   │   │
│   │   ├── Authentication/
│   │   │   ├── LockScreenView.swift
│   │   │   ├── PINEntryView.swift
│   │   │   ├── BiometricPromptView.swift
│   │   │   └── SetupSecurityView.swift
│   │   │
│   │   ├── Search/
│   │   │   ├── GlobalSearchView.swift
│   │   │   ├── SearchResultsView.swift
│   │   │   └── RecentSearchesView.swift
│   │   │
│   │   └── Onboarding/
│   │       ├── OnboardingContainerView.swift
│   │       ├── WelcomeView.swift
│   │       ├── FeaturesOverviewView.swift
│   │       ├── SetupWizardView.swift
│   │       └── SampleDataView.swift
│   │
│   ├── Components/
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift
│   │   │   ├── SecondaryButton.swift
│   │   │   ├── IconButton.swift
│   │   │   └── QuickActionButton.swift
│   │   ├── Cards/
│   │   │   ├── InfoCard.swift
│   │   │   ├── StatCard.swift
│   │   │   ├── EquipmentCard.swift
│   │   │   └── RentalCard.swift
│   │   ├── Badges/
│   │   │   ├── StatusBadge.swift
│   │   │   ├── ConditionBadge.swift
│   │   │   ├── CategoryBadge.swift
│   │   │   └── TagBadge.swift
│   │   ├── Input/
│   │   │   ├── SearchBar.swift
│   │   │   ├── CustomTextField.swift
│   │   │   ├── DateRangePicker.swift
│   │   │   ├── CurrencyTextField.swift
│   │   │   └── TagInputField.swift
│   │   ├── Media/
│   │   │   ├── ImagePicker.swift
│   │   │   ├── MultiImagePicker.swift
│   │   │   ├── ImageGallery.swift
│   │   │   ├── ZoomableImageView.swift
│   │   │   ├── CameraView.swift
│   │   │   └── DocumentPicker.swift
│   │   ├── Feedback/
│   │   │   ├── LoadingView.swift
│   │   │   ├── LoadingOverlay.swift
│   │   │   ├── EmptyStateView.swift
│   │   │   ├── ErrorView.swift
│   │   │   ├── ConfirmationDialog.swift
│   │   │   ├── ToastView.swift
│   │   │   └── ProgressOverlay.swift
│   │   ├── Pickers/
│   │   │   ├── CategoryPicker.swift
│   │   │   ├── ConditionPicker.swift
│   │   │   ├── LocationPicker.swift
│   │   │   ├── CustomerPicker.swift
│   │   │   ├── EquipmentPicker.swift
│   │   │   ├── IconPicker.swift
│   │   │   └── ColorPicker.swift
│   │   ├── Charts/
│   │   │   ├── MiniBarChart.swift
│   │   │   ├── MiniLineChart.swift
│   │   │   ├── DonutChart.swift
│   │   │   └── SparklineView.swift
│   │   └── Common/
│   │       ├── SectionHeader.swift
│   │       ├── DividerWithText.swift
│   │       └── AsyncImageView.swift
│   │
│   ├── Services/
│   │   ├── DataService.swift
│   │   ├── AuthenticationService.swift
│   │   ├── QRCodeService.swift
│   │   ├── BarcodeService.swift
│   │   ├── ImageService.swift
│   │   ├── PDFService.swift
│   │   ├── ExportService.swift
│   │   ├── ImportService.swift
│   │   ├── CloudSyncService.swift
│   │   ├── NotificationService.swift
│   │   ├── CalendarService.swift
│   │   ├── BackupService.swift
│   │   ├── EmailService.swift
│   │   ├── PrintService.swift
│   │   ├── AuditLogService.swift
│   │   ├── StatisticsService.swift
│   │   └── StoreManager.swift
│   │
│   ├── Managers/
│   │   ├── ToastManager.swift
│   │   ├── NavigationManager.swift
│   │   └── AppStateManager.swift
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   │   ├── AppIcon.appiconset/
│   │   │   ├── AccentColor.colorset/
│   │   │   ├── Colors/
│   │   │   │   ├── BrandPrimary.colorset/
│   │   │   │   ├── BrandSecondary.colorset/
│   │   │   │   ├── Success.colorset/
│   │   │   │   ├── Warning.colorset/
│   │   │   │   ├── Error.colorset/
│   │   │   │   ├── Info.colorset/
│   │   │   │   ├── StatusReserved.colorset/
│   │   │   │   ├── StatusActive.colorset/
│   │   │   │   ├── StatusOverdue.colorset/
│   │   │   │   ├── StatusReturned.colorset/
│   │   │   │   ├── BackgroundPrimary.colorset/
│   │   │   │   ├── BackgroundSecondary.colorset/
│   │   │   │   ├── BackgroundTertiary.colorset/
│   │   │   │   ├── TextPrimary.colorset/
│   │   │   │   ├── TextSecondary.colorset/
│   │   │   │   └── TextTertiary.colorset/
│   │   │   └── Images/
│   │   │       ├── logo.imageset/
│   │   │       ├── onboarding1.imageset/
│   │   │       ├── onboarding2.imageset/
│   │   │       ├── onboarding3.imageset/
│   │   │       └── placeholder.imageset/
│   │   ├── Sounds/
│   │   │   ├── scan_success.mp3
│   │   │   └── notification.mp3
│   │   ├── Localizable.xcstrings
│   │   └── InfoPlist.xcstrings
│   │
│   ├── Legal/
│   │   ├── PrivacyPolicy.swift      // In-App Datenschutzerklärung
│   │   ├── TermsOfService.swift     // Nutzungsbedingungen
│   │   └── Licenses.swift           // Open Source Lizenzen (falls nötig)
│   │
│   ├── Info.plist
│   └── MediaTechManager.entitlements
│
├── MediaTechManagerWidget/
│   ├── MediaTechManagerWidget.swift
│   ├── WidgetBundle.swift
│   ├── Views/
│   │   ├── SmallWidgetView.swift
│   │   ├── MediumWidgetView.swift
│   │   └── LargeWidgetView.swift
│   ├── Info.plist
│   └── Assets.xcassets/
│
├── MediaTechManagerIntents/
│   ├── AppIntents.swift
│   ├── ScanEquipmentIntent.swift
│   ├── QuickRentalIntent.swift
│   └── EquipmentStatusIntent.swift
│
├── MediaTechManagerTests/
│   ├── ModelTests/
│   │   ├── EquipmentTests.swift
│   │   ├── RentalTests.swift
│   │   └── CustomerTests.swift
│   ├── ViewModelTests/
│   │   ├── EquipmentViewModelTests.swift
│   │   └── RentalViewModelTests.swift
│   └── ServiceTests/
│       ├── QRCodeServiceTests.swift
│       └── ExportServiceTests.swift
│
├── MediaTechManagerUITests/
│   ├── OnboardingUITests.swift
│   ├── EquipmentUITests.swift
│   └── RentalUITests.swift
│
└── README.md
```

---

## ✅ App Store Submission Checklist

### Vor dem Submit prüfen:

```
CODE & BUILD
[ ] Keine Compiler Warnings
[ ] Keine Debug-Code oder print() Statements
[ ] Keine TODO/FIXME Kommentare
[ ] Alle Assets in korrekter Auflösung (@1x, @2x, @3x)
[ ] App Icon vollständig (alle Größen)
[ ] Launch Screen konfiguriert
[ ] Kein privates API verwendet
[ ] Keine hartkodierten Testdaten

PRIVACY & LEGAL
[ ] Privacy Policy URL live und erreichbar
[ ] Terms of Service URL live und erreichbar
[ ] App Privacy Labels korrekt ausgefüllt
[ ] Alle Info.plist Usage Descriptions vorhanden
[ ] DSGVO-konform
[ ] Impressum vorhanden (für deutsche Apps)

IN-APP PURCHASE
[ ] StoreKit 2 korrekt implementiert
[ ] Restore Purchases funktioniert
[ ] Subscription-Hinweise vorhanden
[ ] Links zu Nutzungsbedingungen

FUNKTIONALITÄT
[ ] App startet ohne Crash
[ ] Alle Features funktionieren
[ ] Offline-Nutzung möglich
[ ] Keine Platzhalter-Inhalte
[ ] Keine Beta-Hinweise

UI/UX
[ ] Dark Mode vollständig unterstützt
[ ] Dynamic Type funktioniert
[ ] VoiceOver funktioniert
[ ] Alle Buttons mindestens 44pt
[ ] Keine UI-Bugs

LOKALISIERUNG
[ ] Deutsche Texte vollständig
[ ] Englische Texte vollständig (falls angeboten)
[ ] Währungsformatierung korrekt

SCREENSHOTS & METADATA
[ ] Screenshots für alle Gerätegrößen
[ ] App Preview Video (optional)
[ ] Beschreibung aktuell
[ ] Keywords optimiert
[ ] Kategorie korrekt

TESTING
[ ] Auf echtem Gerät getestet
[ ] iPhone und iPad getestet
[ ] Alle iOS 17 Geräte funktionieren
[ ] Memory Leaks geprüft
[ ] Performance akzeptabel
```

---

## 🚨 Kritische Implementierungshinweise

1. **KEINE externen Dependencies** - Nur Apple Frameworks
2. **SwiftData korrekt initialisieren** - ModelContainer in App erstellen
3. **@Environment(\.modelContext)** in allen Views
4. **Bilder komprimieren** - Max 500KB pro Bild
5. **Alle Strings auf Deutsch** - Lokalisiert
6. **Fehlerbehandlung** - Try-Catch mit User-Feedback
7. **Async/Await** - Für alle async Operationen
8. **@MainActor** - UI-Updates auf Main Thread
9. **Kein "// TODO"** - Vollständiger Code
10. **Kein print()** - Nur Logger verwenden
11. **Keychain** - Für PIN und sensible Daten
12. **UserDefaults** - Nur für einfache Settings
13. **CloudKit** - Mit Fehlerbehandlung
14. **StoreKit 2** - Mit Verification
15. **Privacy** - Alle Permissions erklären

---

## 📤 Erwartetes Ergebnis

Erstelle alle Dateien mit vollständigem, sofort lauffähigem Code. Das Projekt muss:

1. ✅ In Xcode 15+ ohne Änderungen öffnen
2. ✅ Sofort kompilieren (keine Errors, keine kritischen Warnings)
3. ✅ Auf iPhone 15 Pro Simulator starten
4. ✅ Auf iPad Pro Simulator starten
5. ✅ Alle beschriebenen Features enthalten
6. ✅ Professionelles, natives iOS Design haben
7. ✅ App Store Review Guidelines erfüllen
8. ✅ DSGVO-konform sein
9. ✅ VoiceOver kompatibel sein
10. ✅ Dark Mode vollständig unterstützen

Beginne jetzt mit der Erstellung des kompletten Xcode-Projekts.

# ================================================================================
# ENDE DES PROMPTS - PROFESSIONAL EDITION
# ================================================================================