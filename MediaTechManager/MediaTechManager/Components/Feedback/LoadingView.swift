//
//  LoadingView.swift
//  MediaTechManager
//
//  Lade-Ansicht
//

import SwiftUI

struct LoadingView: View {

    // MARK: - Properties

    let message: String

    // MARK: - Initializer

    init(_ message: String = "Laden...") {
        self.message = message
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)

            Text(message)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Loading Overlay Modifier

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                Color.black.opacity(0.3)
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
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            }
        }
        .animation(.standard, value: isLoading)
    }
}

// MARK: - Skeleton Loading View

struct SkeletonView: View {
    @State private var isAnimating = false

    let width: CGFloat?
    let height: CGFloat

    init(width: CGFloat? = nil, height: CGFloat = 20) {
        self.width = width
        self.height = height
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.2),
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.2)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.xl) {
        LoadingView()
            .frame(height: 200)

        SkeletonView(width: 200, height: 20)
        SkeletonView(width: 150, height: 16)
        SkeletonView(height: 100)
    }
    .padding()
}
