//
//  MediaTechManagerApp.swift
//  MediaTechManager
//
//  Professionelle iOS App für Medientechnik-Verwaltung und Geräteverleih
//

import SwiftUI
import SwiftData

@main
struct MediaTechManagerApp: App {

    // MARK: - Properties

    @StateObject private var appState = AppStateManager()
    @StateObject private var toastManager = ToastManager()

    // MARK: - SwiftData Configuration

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Equipment.self,
            Customer.self,
            Rental.self,
            Category.self,
            Condition.self,
            Location.self,
            Tag.self,
            MaintenanceRecord.self,
            DamageReport.self,
            AuditLog.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Konnte ModelContainer nicht erstellen: \(error)")
        }
    }()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(toastManager)
                .modelContainer(sharedModelContainer)
                .onAppear {
                    setupAppearance()
                    initializeSeedData()
                }
        }
    }

    // MARK: - Seed Data

    @MainActor
    private func initializeSeedData() {
        DataService.initializeSeedData(context: sharedModelContainer.mainContext)
    }

    // MARK: - Setup

    private func setupAppearance() {
        // Tab Bar Appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Navigation Bar Appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
