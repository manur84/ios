//
//  SearchBar.swift
//  MediaTechManager
//
//  Suchleiste
//

import SwiftUI

struct SearchBar: View {

    // MARK: - Properties

    @Binding var text: String
    let placeholder: String
    var onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Initializer

    init(
        text: Binding<String>,
        placeholder: String = "Suchen...",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 16))

            // Text Field
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    onSubmit?()
                }

            // Clear Button
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""), placeholder: "Geräte suchen...")

        SearchBar(text: .constant("Canon"), placeholder: "Geräte suchen...")
    }
    .padding()
}
