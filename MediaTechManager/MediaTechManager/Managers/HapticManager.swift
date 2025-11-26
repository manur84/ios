//
//  HapticManager.swift
//  MediaTechManager
//
//  Haptisches Feedback
//

import UIKit

enum HapticManager {

    // MARK: - Impact Feedback

    /// Leichtes haptisches Feedback (z.B. für Button-Taps)
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// Mittleres haptisches Feedback
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// Schweres haptisches Feedback (z.B. für wichtige Aktionen)
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    /// Weiches haptisches Feedback
    static func soft() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }

    /// Starres haptisches Feedback
    static func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }

    // MARK: - Notification Feedback

    /// Erfolgs-Feedback
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// Warn-Feedback
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// Fehler-Feedback
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    // MARK: - Selection Feedback

    /// Selection Changed Feedback
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    // MARK: - Custom Patterns

    /// Doppeltes Tap-Feedback
    static func doubleTap() {
        light()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            light()
        }
    }

    /// Dreifaches Tap-Feedback (für spezielle Aktionen)
    static func tripleTap() {
        light()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            light()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            medium()
        }
    }
}

// MARK: - SwiftUI Integration

import SwiftUI

extension View {
    /// Fügt haptisches Feedback bei Tap hinzu
    func hapticFeedback(_ style: HapticStyle = .light) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                switch style {
                case .light:
                    HapticManager.light()
                case .medium:
                    HapticManager.medium()
                case .heavy:
                    HapticManager.heavy()
                case .success:
                    HapticManager.success()
                case .warning:
                    HapticManager.warning()
                case .error:
                    HapticManager.error()
                case .selection:
                    HapticManager.selection()
                }
            }
        )
    }
}

enum HapticStyle {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}
