//
//  ShakeEffect.swift
//  MediaTechManager
//
//  Shake-Effekt für Fehlereingaben
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}

// MARK: - View Extension

extension View {
    func shake(trigger: Int) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}

struct ShakeModifier: ViewModifier {
    let trigger: Int
    @State private var shakeCount: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: shakeCount))
            .onChange(of: trigger) { _, _ in
                withAnimation(.linear(duration: 0.4)) {
                    shakeCount += 1
                }
            }
    }
}

// MARK: - Pulse Effect

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseEffect())
    }
}

// MARK: - Glow Effect

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.5), radius: radius / 2)
            .shadow(color: color.opacity(0.3), radius: radius)
    }
}

extension View {
    func glow(color: Color = .blue, radius: CGFloat = 10) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.xl) {
        Text("Shake Effect")
            .padding()
            .background(Color.red.opacity(0.2))
            .shake(trigger: 0)

        Circle()
            .fill(Color.blue)
            .frame(width: 50, height: 50)
            .pulse()

        Text("Glow Effect")
            .font(.title)
            .glow(color: .purple)
    }
}
