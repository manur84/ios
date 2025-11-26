//
//  SettingsView.swift
//  MediaTechManager
//
//  Einstellungen
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Environment

    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - State

    @State private var showExportImport = false
    @State private var showBackupRestore = false
    @State private var showAbout = false
    @State private var showPrivacyPolicy = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                // Darstellung
                Section("Darstellung") {
                    Picker("Erscheinungsbild", selection: $appState.darkModePreference) {
                        ForEach(AppStateManager.DarkModePreference.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                }

                // Sicherheit
                Section("Sicherheit") {
                    Toggle("App-Sperre aktivieren", isOn: $appState.securityEnabled)

                    if appState.securityEnabled {
                        Toggle("Face ID / Touch ID", isOn: $appState.biometricEnabled)

                        Toggle("Auto-Sperre", isOn: $appState.autoLockEnabled)

                        if appState.autoLockEnabled {
                            Picker("Timeout", selection: $appState.autoLockTimeout) {
                                Text("1 Minute").tag(TimeInterval(60))
                                Text("5 Minuten").tag(TimeInterval(300))
                                Text("15 Minuten").tag(TimeInterval(900))
                                Text("30 Minuten").tag(TimeInterval(1800))
                            }
                        }

                        NavigationLink("PIN ändern") {
                            PINSetupView()
                        }
                    }
                }

                // Stammdaten
                Section("Stammdaten") {
                    NavigationLink("Kategorien") {
                        CategoryManagementView()
                    }

                    NavigationLink("Zustände") {
                        ConditionManagementView()
                    }

                    NavigationLink("Standorte") {
                        LocationManagementView()
                    }
                }

                // Daten
                Section("Daten") {
                    Button("Export / Import") {
                        showExportImport = true
                    }

                    Button("Backup / Wiederherstellen") {
                        showBackupRestore = true
                    }
                }

                // Info
                Section("Info") {
                    Button("Datenschutzerklärung") {
                        showPrivacyPolicy = true
                    }

                    NavigationLink("Über die App") {
                        AboutView()
                    }
                }

                // Version
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Constants.App.fullVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .sheet(isPresented: $showExportImport) {
                ExportImportView()
            }
            .sheet(isPresented: $showBackupRestore) {
                BackupRestoreView()
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: Spacing.md) {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color(hex: "007AFF"))

                    Text(Constants.App.name)
                        .font(.titleLarge)

                    Text("Professionelle Medientechnik-Verwaltung")
                        .font(.bodyMedium)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.lg)
            }

            Section("Kontakt") {
                Link(destination: URL(string: "mailto:\(Constants.URLs.supportEmail)")!) {
                    Label(Constants.URLs.supportEmail, systemImage: "envelope")
                }

                Link(destination: Constants.URLs.website) {
                    Label("Website", systemImage: "globe")
                }
            }

            Section("Rechtliches") {
                Link(destination: Constants.URLs.privacyPolicy) {
                    Label("Datenschutzerklärung", systemImage: "hand.raised")
                }

                Link(destination: Constants.URLs.termsOfService) {
                    Label("Nutzungsbedingungen", systemImage: "doc.text")
                }
            }
        }
        .navigationTitle("Über")
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
