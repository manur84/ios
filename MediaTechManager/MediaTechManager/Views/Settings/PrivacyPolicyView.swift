//
//  PrivacyPolicyView.swift
//  MediaTechManager
//
//  Datenschutzerklärung (DSGVO-konform)
//

import SwiftUI

struct PrivacyPolicyView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Datenschutzerklärung")
                            .font(.displaySmall)

                        Text("Letzte Aktualisierung: \(Date().formatted(date: .abbreviated, time: .omitted))")
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    // Content
                    Group {
                        section1_verantwortlicher
                        section2_datenerhebung
                        section3_datenspeicherung
                        section4_datenweitergabe
                        section5_rechte
                        section6_datensicherheit
                        section7_kontakt
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") { dismiss() }
                }
            }
        }
    }

    // MARK: - Section 1

    private var section1_verantwortlicher: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("1. Verantwortlicher")
                .font(.titleMedium)

            Text("""
            Verantwortlich für die Datenverarbeitung innerhalb dieser App ist der Nutzer selbst, da alle Daten ausschließlich lokal auf dem Gerät gespeichert werden.

            MediaTechManager ist eine lokale Anwendung zur Verwaltung von Medientechnik-Equipment. Es werden keine Daten an externe Server übertragen.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 2

    private var section2_datenerhebung: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("2. Erhobene Daten")
                .font(.titleMedium)

            Text("""
            Die App erhebt und verarbeitet folgende Daten, die Sie selbst eingeben:

            **Kundendaten:**
            • Name, Vorname
            • Firma/Organisation
            • Kontaktdaten (E-Mail, Telefon)
            • Adressdaten

            **Gerätedaten:**
            • Inventarnummern
            • Seriennummern
            • Beschreibungen und Notizen
            • Fotos der Geräte

            **Ausleihvorgänge:**
            • Zeiträume
            • Zugewiesene Geräte
            • Unterschriften (digital)

            Diese Daten werden ausschließlich für die Verwaltung Ihrer Medientechnik verwendet und nicht an Dritte weitergegeben.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 3

    private var section3_datenspeicherung: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("3. Datenspeicherung")
                .font(.titleMedium)

            Text("""
            **Lokale Speicherung:**
            Alle Daten werden ausschließlich lokal auf Ihrem Gerät gespeichert. Es erfolgt keine Übertragung an externe Server oder Cloud-Dienste.

            **Speicherdauer:**
            Die Daten bleiben gespeichert, bis Sie diese manuell löschen oder die App deinstallieren.

            **Backup:**
            Bei aktiviertem iCloud-Backup können die App-Daten als Teil des Geräte-Backups gesichert werden. Dies liegt in Ihrer Verantwortung und unterliegt den Apple-Datenschutzrichtlinien.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 4

    private var section4_datenweitergabe: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("4. Datenweitergabe")
                .font(.titleMedium)

            Text("""
            **Keine automatische Weitergabe:**
            Die App gibt keine Daten automatisch an Dritte weiter.

            **Export-Funktionen:**
            Sie können Daten manuell exportieren (z.B. als PDF). Die Weitergabe dieser Exporte liegt in Ihrer Verantwortung.

            **Teilen-Funktion:**
            Wenn Sie Inhalte über die Teilen-Funktion weitergeben, werden diese an die von Ihnen gewählten Apps/Dienste übertragen.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 5

    private var section5_rechte: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("5. Ihre Rechte (DSGVO)")
                .font(.titleMedium)

            Text("""
            Gemäß der Datenschutz-Grundverordnung (DSGVO) haben Sie folgende Rechte:

            **Auskunftsrecht (Art. 15 DSGVO):**
            Da alle Daten lokal auf Ihrem Gerät gespeichert sind, haben Sie jederzeit vollständigen Zugriff auf alle Ihre Daten.

            **Recht auf Berichtigung (Art. 16 DSGVO):**
            Sie können alle Daten jederzeit in der App bearbeiten.

            **Recht auf Löschung (Art. 17 DSGVO):**
            Sie können einzelne Einträge oder alle Daten jederzeit löschen.

            **Recht auf Datenübertragbarkeit (Art. 20 DSGVO):**
            Sie können Ihre Daten über die Export-Funktion exportieren.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 6

    private var section6_datensicherheit: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("6. Datensicherheit")
                .font(.titleMedium)

            Text("""
            **Geräteschutz:**
            Die Sicherheit Ihrer Daten hängt von den Sicherheitseinstellungen Ihres Geräts ab (PIN, Face ID, Touch ID).

            **App-Schutz:**
            Die App bietet zusätzliche Sicherheitsfunktionen wie PIN-Schutz und biometrische Authentifizierung.

            **Keychain:**
            Sensible Daten wie PINs werden verschlüsselt in der iOS Keychain gespeichert.

            **Empfehlungen:**
            • Aktivieren Sie die Geräteverschlüsselung
            • Verwenden Sie einen starken Geräte-Passcode
            • Aktivieren Sie den App-internen Schutz
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Section 7

    private var section7_kontakt: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("7. Kontakt")
                .font(.titleMedium)

            Text("""
            Bei Fragen zum Datenschutz in dieser App wenden Sie sich bitte an den App-Entwickler über die im App Store angegebenen Kontaktinformationen.

            Diese Datenschutzerklärung kann jederzeit geändert werden. Die aktuelle Version ist in der App einsehbar.
            """)
            .font(.bodyMedium)
            .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    PrivacyPolicyView()
}
