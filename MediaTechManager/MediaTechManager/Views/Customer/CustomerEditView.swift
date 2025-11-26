//
//  CustomerEditView.swift
//  MediaTechManager
//
//  Kunde hinzufügen/bearbeiten
//

import SwiftUI
import SwiftData

struct CustomerEditView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let customer: Customer?
    private var isNew: Bool { customer == nil }

    // MARK: - State

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var company = ""
    @State private var customerNumber = ""
    @State private var customerType: CustomerType = .private

    @State private var email = ""
    @State private var phone = ""
    @State private var mobile = ""

    @State private var street = ""
    @State private var postalCode = ""
    @State private var city = ""
    @State private var country = "Deutschland"

    @State private var notes = ""

    @State private var isSaving = false

    // MARK: - Initializer

    init(customer: Customer?) {
        self.customer = customer
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                // Grunddaten
                Section("Grunddaten") {
                    TextField("Vorname *", text: $firstName)
                        .textContentType(.givenName)

                    TextField("Nachname *", text: $lastName)
                        .textContentType(.familyName)

                    TextField("Firma", text: $company)
                        .textContentType(.organizationName)

                    HStack {
                        TextField("Kundennummer", text: $customerNumber)

                        Button {
                            customerNumber = appState.nextCustomerNumber()
                        } label: {
                            Image(systemName: "wand.and.stars")
                        }
                    }

                    Picker("Kundentyp", selection: $customerType) {
                        ForEach(CustomerType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }

                // Kontakt
                Section("Kontakt") {
                    TextField("E-Mail *", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    TextField("Telefon", text: $phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)

                    TextField("Mobil", text: $mobile)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }

                // Adresse
                Section("Adresse") {
                    TextField("Straße und Hausnummer", text: $street)
                        .textContentType(.streetAddressLine1)

                    HStack {
                        TextField("PLZ", text: $postalCode)
                            .textContentType(.postalCode)
                            .keyboardType(.numberPad)
                            .frame(width: 80)

                        TextField("Stadt", text: $city)
                            .textContentType(.addressCity)
                    }

                    TextField("Land", text: $country)
                        .textContentType(.countryName)
                }

                // Notizen
                Section("Notizen") {
                    TextField("Interne Notizen", text: $notes, axis: .vertical)
                        .lineLimit(3...10)
                }
            }
            .navigationTitle(isNew ? "Neuer Kunde" : "Kunde bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        save()
                    }
                    .disabled(!canSave || isSaving)
                }
            }
            .onAppear {
                loadCustomerData()
            }
        }
    }

    // MARK: - Computed Properties

    private var canSave: Bool {
        !firstName.isEmpty && !lastName.isEmpty && email.isValidEmail
    }

    // MARK: - Load Data

    private func loadCustomerData() {
        guard let customer else {
            // Generate customer number for new customer
            if customerNumber.isEmpty {
                customerNumber = appState.nextCustomerNumber()
            }
            return
        }

        firstName = customer.firstName
        lastName = customer.lastName
        company = customer.company ?? ""
        customerNumber = customer.customerNumber
        customerType = customer.customerType
        email = customer.email
        phone = customer.phone
        mobile = customer.mobile ?? ""
        street = customer.street
        postalCode = customer.postalCode
        city = customer.city
        country = customer.country
        notes = customer.notes
    }

    // MARK: - Save

    private func save() {
        isSaving = true

        let targetCustomer = customer ?? Customer(
            firstName: firstName,
            lastName: lastName,
            email: email,
            customerType: customerType
        )

        targetCustomer.firstName = firstName
        targetCustomer.lastName = lastName
        targetCustomer.company = company.isEmpty ? nil : company
        targetCustomer.customerNumber = customerNumber
        targetCustomer.customerType = customerType
        targetCustomer.email = email
        targetCustomer.phone = phone
        targetCustomer.mobile = mobile.isEmpty ? nil : mobile
        targetCustomer.street = street
        targetCustomer.postalCode = postalCode
        targetCustomer.city = city
        targetCustomer.country = country
        targetCustomer.notes = notes
        targetCustomer.updatedAt = Date()

        if isNew {
            modelContext.insert(targetCustomer)
        }

        do {
            try modelContext.save()
            toastManager.success(isNew ? "Kunde erstellt" : "Änderungen gespeichert")
            dismiss()
        } catch {
            Logger.error(error, message: "Failed to save customer")
            toastManager.error("Speichern fehlgeschlagen")
            isSaving = false
        }
    }
}

// MARK: - Preview

#Preview {
    CustomerEditView(customer: nil)
        .environmentObject(AppStateManager())
        .environmentObject(ToastManager())
}
