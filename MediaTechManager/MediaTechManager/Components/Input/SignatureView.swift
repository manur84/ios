//
//  SignatureView.swift
//  MediaTechManager
//
//  Unterschrift-Erfassung für Protokolle
//

import SwiftUI

struct SignatureView: View {

    // MARK: - Binding

    @Binding var signature: UIImage?

    // MARK: - State

    @State private var lines: [Line] = []
    @State private var currentLine = Line()

    // MARK: - Body

    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Canvas
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)

                    context.stroke(
                        path,
                        with: .color(.primary),
                        lineWidth: line.lineWidth
                    )
                }

                var currentPath = Path()
                currentPath.addLines(currentLine.points)

                context.stroke(
                    currentPath,
                    with: .color(.primary),
                    lineWidth: currentLine.lineWidth
                )
            }
            .frame(height: 150)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        currentLine.points.append(value.location)
                    }
                    .onEnded { _ in
                        lines.append(currentLine)
                        currentLine = Line()
                        generateSignatureImage()
                    }
            )

            // Placeholder
            if lines.isEmpty && currentLine.points.isEmpty {
                Text("Hier unterschreiben")
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .allowsHitTesting(false)
                    .offset(y: -90)
            }

            // Clear Button
            HStack {
                Spacer()

                Button {
                    clearSignature()
                } label: {
                    Label("Löschen", systemImage: "trash")
                        .font(.labelSmall)
                }
                .disabled(lines.isEmpty && currentLine.points.isEmpty)
            }
        }
    }

    // MARK: - Actions

    private func clearSignature() {
        lines = []
        currentLine = Line()
        signature = nil
    }

    private func generateSignatureImage() {
        let renderer = ImageRenderer(content: signatureCanvas)
        renderer.scale = UIScreen.main.scale

        if let uiImage = renderer.uiImage {
            signature = uiImage
        }
    }

    private var signatureCanvas: some View {
        Canvas { context, size in
            for line in lines {
                var path = Path()
                path.addLines(line.points)

                context.stroke(
                    path,
                    with: .color(.black),
                    lineWidth: line.lineWidth
                )
            }
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
    }
}

// MARK: - Line

struct Line {
    var points: [CGPoint] = []
    var lineWidth: CGFloat = 2.0
}

// MARK: - Signature Capture View

struct SignatureCaptureView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var signatureImage: UIImage?
    let title: String

    @State private var tempSignature: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Text(title)
                    .font(.titleMedium)
                    .padding(.top, Spacing.lg)

                SignatureView(signature: $tempSignature)
                    .padding(.horizontal, Spacing.lg)

                Spacer()

                VStack(spacing: Spacing.sm) {
                    PrimaryButton("Bestätigen", icon: "checkmark") {
                        signatureImage = tempSignature
                        dismiss()
                    }
                    .disabled(tempSignature == nil)

                    SecondaryButton("Abbrechen") {
                        dismiss()
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Signature Display View

struct SignatureDisplayView: View {
    let signature: UIImage?
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.labelSmall)
                .foregroundStyle(.secondary)

            if let image = signature {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .padding(Spacing.sm)
                    .background(Color.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
            } else {
                HStack {
                    Image(systemName: "signature")
                        .foregroundStyle(.secondary)
                    Text("Keine Unterschrift")
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(Color.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Spacing.xl) {
        SignatureView(signature: .constant(nil))
            .padding()

        SignatureDisplayView(signature: nil, label: "Unterschrift Mieter")
            .padding()
    }
}
