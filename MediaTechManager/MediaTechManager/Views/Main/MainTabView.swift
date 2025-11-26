//
//  MainTabView.swift
//  MediaTechManager
//
//  Haupt-Tab-Navigation
//

import SwiftUI

struct MainTabView: View {

    // MARK: - Environment

    @EnvironmentObject private var appState: AppStateManager

    // MARK: - Body

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            // Dashboard Tab
            DashboardView()
                .tabItem {
                    Label(
                        AppStateManager.Tab.dashboard.title,
                        systemImage: AppStateManager.Tab.dashboard.icon
                    )
                }
                .tag(AppStateManager.Tab.dashboard)

            // Inventar/Equipment Tab
            EquipmentListView()
                .tabItem {
                    Label(
                        AppStateManager.Tab.equipment.title,
                        systemImage: AppStateManager.Tab.equipment.icon
                    )
                }
                .tag(AppStateManager.Tab.equipment)

            // Ausleihen Tab
            RentalListView()
                .tabItem {
                    Label(
                        AppStateManager.Tab.rentals.title,
                        systemImage: AppStateManager.Tab.rentals.icon
                    )
                }
                .tag(AppStateManager.Tab.rentals)

            // Kunden Tab
            CustomerListView()
                .tabItem {
                    Label(
                        AppStateManager.Tab.customers.title,
                        systemImage: AppStateManager.Tab.customers.icon
                    )
                }
                .tag(AppStateManager.Tab.customers)

            // Einstellungen Tab
            SettingsView()
                .tabItem {
                    Label(
                        AppStateManager.Tab.settings.title,
                        systemImage: AppStateManager.Tab.settings.icon
                    )
                }
                .tag(AppStateManager.Tab.settings)
        }
        .tint(.brandPrimary)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
