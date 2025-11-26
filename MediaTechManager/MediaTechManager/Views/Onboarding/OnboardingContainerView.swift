//
//  OnboardingContainerView.swift
//  MediaTechManager
//
//  Onboarding Flow
//

import SwiftUI

struct OnboardingContainerView: View {

    // MARK: - Environment

    @EnvironmentObject private var appState: AppStateManager

    // MARK: - State

    @State private var currentPage = 0

    // MARK: - Data

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "shippingbox.fill",
            title: "Willkommen bei MediaTechManager",
            description: "Verwalten Sie Ihre gesamte Medientechnik an einem Ort. Behalten Sie den Überblick über Kameras, Objektive, Licht und mehr."
        ),
        OnboardingPage(
            icon: "arrow.left.arrow.right",
            title: "Einfaches Verleihen",
            description: "Erstellen Sie Ausleihen mit wenigen Klicks. Digitale Übergabe- und Rücknahmeprotokolle mit Unterschrift."
        ),
        OnboardingPage(
            icon: "qrcode.viewfinder",
            title: "QR-Code System",
            description: "Generieren Sie QR-Codes für jedes Gerät. Scannen Sie für schnelle Identifikation und starten Sie Ausleihen direkt per Scan."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Statistiken & Berichte",
            description: "Analysieren Sie Auslastung und Umsatz. Erstellen Sie professionelle PDF-Berichte."
        )
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Pages
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Bottom Section
            VStack(spacing: Spacing.lg) {
                // Page Indicator
                HStack(spacing: Spacing.xs) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color(hex: "007AFF") : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }

                // Buttons
                if currentPage < pages.count - 1 {
                    HStack(spacing: Spacing.md) {
                        Button("Überspringen") {
                            completeOnboarding()
                        }
                        .foregroundStyle(.secondary)

                        Spacer()

                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            HStack {
                                Text("Weiter")
                                Image(systemName: "arrow.right")
                            }
                            .font(.titleSmall)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    PrimaryButton("Loslegen", icon: "arrow.right") {
                        completeOnboarding()
                    }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.backgroundPrimary)
    }

    // MARK: - Actions

    private func completeOnboarding() {
        withAnimation {
            appState.onboardingCompleted = true
        }
    }
}

// MARK: - Onboarding Page

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(Color(hex: "007AFF"))

            VStack(spacing: Spacing.sm) {
                Text(page.title)
                    .font(.displaySmall)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.bodyLarge)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }

            Spacer()
            Spacer()
        }
        .padding(Spacing.lg)
    }
}

// MARK: - Preview

#Preview {
    OnboardingContainerView()
        .environmentObject(AppStateManager())
}
