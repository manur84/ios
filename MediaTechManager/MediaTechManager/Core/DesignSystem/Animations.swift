//
//  Animations.swift
//  MediaTechManager
//
//  Design System - Animationsdefinitionen
//

import SwiftUI

extension Animation {

    // MARK: - Duration-based Animations

    /// Schnelle Animation - 0.2s
    static let quick = Animation.easeInOut(duration: 0.2)

    /// Standard Animation - 0.3s
    static let standard = Animation.easeInOut(duration: 0.3)

    /// Sanfte Animation - 0.4s
    static let smooth = Animation.easeInOut(duration: 0.4)

    /// Langsame Animation - 0.5s
    static let slow = Animation.easeInOut(duration: 0.5)

    // MARK: - Spring Animations

    /// Standard Spring
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)

    /// Bouncy Spring
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)

    /// Snappy Spring
    static let snappy = Animation.spring(response: 0.25, dampingFraction: 0.8)

    /// Gentle Spring
    static let gentle = Animation.spring(response: 0.5, dampingFraction: 0.75)

    // MARK: - Specific Use Case Animations

    /// Karten-Erscheinen Animation
    static let cardAppear = Animation.spring(response: 0.5, dampingFraction: 0.8)

    /// Modal-Präsentation Animation
    static let modalPresent = Animation.spring(response: 0.4, dampingFraction: 0.85)

    /// Button-Press Animation
    static let buttonPress = Animation.easeInOut(duration: 0.15)

    /// List-Item Animation
    static let listItem = Animation.spring(response: 0.35, dampingFraction: 0.7)

    /// Fade Animation
    static let fade = Animation.easeInOut(duration: 0.25)

    /// Slide Animation
    static let slide = Animation.spring(response: 0.35, dampingFraction: 0.8)
}

// MARK: - Transition Extensions

extension AnyTransition {

    /// Slide von unten mit Fade
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }

    /// Slide von rechts mit Fade
    static var slideRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }

    /// Scale mit Fade
    static var scaleAndFade: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 0.9).combined(with: .opacity)
        )
    }

    /// Toast Transition
    static var toast: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
}

// MARK: - View Modifier für reduzierte Bewegung

struct ReducedMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let animation: Animation?

    func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? nil : animation, value: UUID())
    }
}

extension View {

    /// Wendet Animation nur an, wenn Reduce Motion deaktiviert ist
    func animationWithReducedMotion(_ animation: Animation?) -> some View {
        modifier(ReducedMotionModifier(animation: animation))
    }
}

// MARK: - Shake Effect für Fehler

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {

    /// Schüttel-Animation für Fehler
    func shake(trigger: Int) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}

struct ShakeModifier: ViewModifier {
    let trigger: Int
    @State private var shake: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: shake))
            .onChange(of: trigger) { _, _ in
                withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                    shake += 1
                }
            }
    }
}
