//
//  ContentView.swift
//  MediaTechManager
//
//  Haupt-Content View - Entry Point für die UI
//

import SwiftUI

struct ContentView: View {

    // MARK: - Environment

    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - State

    @State private var showOnboarding = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // Main Content
            if appState.onboardingCompleted {
                mainContent
            } else {
                onboardingContent
            }

            // Lock Screen Overlay
            if appState.isLocked && appState.securityEnabled {
                LockScreenView()
                    .transition(.opacity)
            }
        }
        .toastContainer(toastManager)
        .animation(.standard, value: appState.isLocked)
        .animation(.standard, value: appState.onboardingCompleted)
        .preferredColorScheme(appState.darkModePreference.colorScheme)
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        MainTabView()
    }

    // MARK: - Onboarding

    @ViewBuilder
    private var onboardingContent: some View {
        OnboardingContainerView()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
