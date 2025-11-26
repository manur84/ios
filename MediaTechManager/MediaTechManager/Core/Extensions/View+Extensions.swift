//
//  View+Extensions.swift
//  MediaTechManager
//
//  View Extensions
//

import SwiftUI

extension View {

    // MARK: - Conditional Modifiers

    /// Wendet einen Modifier nur an, wenn die Bedingung erfüllt ist
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Wendet einen Modifier an, wenn der Wert nicht nil ist
    @ViewBuilder
    func ifLet<Value, Content: View>(_ value: Value?, transform: (Self, Value) -> Content) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }

    // MARK: - Card Style

    /// Standard Karten-Stil
    func cardStyle() -> some View {
        self
            .padding(Spacing.cardPadding)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
            .shadow(.small)
    }

    /// Karten-Stil mit Rahmen
    func cardStyleWithBorder(_ color: Color = .gray.opacity(0.2)) -> some View {
        self
            .padding(Spacing.cardPadding)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge)
                    .stroke(color, lineWidth: Layout.borderWidth)
            )
    }

    // MARK: - Loading Overlay

    /// Zeigt ein Loading Overlay an
    func loadingOverlay(isLoading: Bool, message: String = "Laden...") -> some View {
        ZStack {
            self

            if isLoading {
                LoadingOverlayView(message: message)
            }
        }
    }

    // MARK: - Hide Keyboard

    /// Versteckt die Tastatur
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// Modifier um Tastatur bei Tap zu schließen
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }

    // MARK: - Navigation

    /// Navigation Title mit großem Titel
    func navigationTitleLarge(_ title: String) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
    }

    /// Navigation Title mit inline Titel
    func navigationTitleInline(_ title: String) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Safe Area

    /// Liest die Safe Area Insets
    func readSafeAreaInsets(_ insets: Binding<EdgeInsets>) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        insets.wrappedValue = geometry.safeAreaInsets
                    }
            }
        )
    }

    // MARK: - Frame

    /// Setzt Frame auf maximale Breite und Höhe
    func frameMax(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

    /// Setzt Frame auf maximale Breite
    func frameMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }

    // MARK: - Debug

    /// Debug Border (nur für Entwicklung)
    func debugBorder(_ color: Color = .red) -> some View {
        #if DEBUG
        return self.border(color)
        #else
        return self
        #endif
    }
}

// MARK: - Loading Overlay View

struct LoadingOverlayView: View {
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

// MARK: - Placeholder Modifier

extension View {

    /// Zeigt einen Platzhalter, wenn die Bedingung erfüllt ist
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
