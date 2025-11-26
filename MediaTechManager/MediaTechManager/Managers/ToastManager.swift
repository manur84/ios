//
//  ToastManager.swift
//  MediaTechManager
//
//  Manager für Toast-Benachrichtigungen
//

import SwiftUI

/// Manager für Toast-Benachrichtigungen
@MainActor
final class ToastManager: ObservableObject {

    // MARK: - Types

    struct Toast: Identifiable, Equatable {
        let id = UUID()
        let message: String
        let type: ToastType
        let duration: TimeInterval

        static func == (lhs: Toast, rhs: Toast) -> Bool {
            lhs.id == rhs.id
        }
    }

    enum ToastType {
        case success
        case error
        case warning
        case info

        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .success: return .success
            case .error: return .error
            case .warning: return .warning
            case .info: return .info
            }
        }

        var fallbackColor: Color {
            switch self {
            case .success: return Color(hex: "34C759")
            case .error: return Color(hex: "FF3B30")
            case .warning: return Color(hex: "FF9500")
            case .info: return Color(hex: "5AC8FA")
            }
        }
    }

    // MARK: - Properties

    @Published var currentToast: Toast?

    private var dismissTask: Task<Void, Never>?

    // MARK: - Methods

    /// Zeigt einen Toast an
    func show(_ message: String, type: ToastType = .info, duration: TimeInterval = 3.0) {
        // Vorherigen Task abbrechen
        dismissTask?.cancel()

        // Neuen Toast setzen
        withAnimation(.spring) {
            currentToast = Toast(message: message, type: type, duration: duration)
        }

        // Auto-dismiss
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(duration))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                withAnimation(.spring) {
                    self.currentToast = nil
                }
            }
        }
    }

    /// Zeigt einen Erfolgs-Toast
    func success(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .success, duration: duration)
    }

    /// Zeigt einen Fehler-Toast
    func error(_ message: String, duration: TimeInterval = 4.0) {
        show(message, type: .error, duration: duration)
    }

    /// Zeigt einen Warnung-Toast
    func warning(_ message: String, duration: TimeInterval = 3.5) {
        show(message, type: .warning, duration: duration)
    }

    /// Zeigt einen Info-Toast
    func info(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .info, duration: duration)
    }

    /// Versteckt den aktuellen Toast
    func dismiss() {
        dismissTask?.cancel()
        withAnimation(.spring) {
            currentToast = nil
        }
    }
}

// MARK: - Toast View

struct ToastView: View {
    let toast: ToastManager.Toast
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: toast.type.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(toast.type.fallbackColor)

            Text(toast.message)
                .font(.bodyMedium)
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, Spacing.md)
    }
}

// MARK: - Toast Container Modifier

struct ToastContainerModifier: ViewModifier {
    @ObservedObject var toastManager: ToastManager

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                if let toast = toastManager.currentToast {
                    ToastView(toast: toast) {
                        toastManager.dismiss()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(999)
                }

                Spacer()
            }
            .animation(.spring, value: toastManager.currentToast)
        }
    }
}

extension View {
    /// Fügt einen Toast-Container hinzu
    func toastContainer(_ toastManager: ToastManager) -> some View {
        modifier(ToastContainerModifier(toastManager: toastManager))
    }
}
