//
//  QRCodeScannerView.swift
//  MediaTechManager
//
//  QR-Code Scanner für Geräte-Identifikation
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let onScan: (String) -> Void

    // MARK: - State

    @State private var isScanning = true
    @State private var scannedCode: String?
    @State private var torchOn = false
    @State private var showPermissionDenied = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Camera Preview
                CameraPreviewView(
                    isScanning: $isScanning,
                    torchOn: $torchOn,
                    onCodeScanned: handleScannedCode
                )
                .ignoresSafeArea()

                // Overlay
                scannerOverlay

                // Permission Denied
                if showPermissionDenied {
                    permissionDeniedView
                }
            }
            .navigationTitle("QR-Code scannen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        torchOn.toggle()
                    } label: {
                        Image(systemName: torchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    }
                }
            }
            .onAppear {
                checkCameraPermission()
            }
        }
    }

    // MARK: - Scanner Overlay

    private var scannerOverlay: some View {
        VStack {
            Spacer()

            // Scan Frame
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 250, height: 250)

                // Corner Accents
                ScannerCorners()
                    .stroke(Color(hex: "007AFF"), lineWidth: 4)
                    .frame(width: 250, height: 250)
            }

            Spacer()

            // Instructions
            VStack(spacing: Spacing.sm) {
                Text("QR-Code in den Rahmen halten")
                    .font(.bodyLarge)
                    .foregroundStyle(.white)

                Text("Der Code wird automatisch erkannt")
                    .font(.bodySmall)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.bottom, Spacing.xxxl)
        }
    }

    // MARK: - Permission Denied View

    private var permissionDeniedView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("Kamera-Zugriff benötigt")
                .font(.titleLarge)

            Text("Bitte erlauben Sie den Kamera-Zugriff in den Einstellungen, um QR-Codes scannen zu können.")
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)

            Button("Einstellungen öffnen") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(Spacing.xl)
        .background(Color.backgroundPrimary)
    }

    // MARK: - Actions

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isScanning = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isScanning = true
                    } else {
                        showPermissionDenied = true
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDenied = true
        @unknown default:
            showPermissionDenied = true
        }
    }

    private func handleScannedCode(_ code: String) {
        guard scannedCode == nil else { return }

        scannedCode = code
        isScanning = false

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Process code
        onScan(code)
        dismiss()
    }
}

// MARK: - Scanner Corners Shape

struct ScannerCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = 30

        // Top Left
        path.move(to: CGPoint(x: 0, y: cornerLength))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: cornerLength, y: 0))

        // Top Right
        path.move(to: CGPoint(x: rect.width - cornerLength, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: cornerLength))

        // Bottom Right
        path.move(to: CGPoint(x: rect.width, y: rect.height - cornerLength))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - cornerLength, y: rect.height))

        // Bottom Left
        path.move(to: CGPoint(x: cornerLength, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height - cornerLength))

        return path
    }
}

// MARK: - Camera Preview View

struct CameraPreviewView: UIViewRepresentable {
    @Binding var isScanning: Bool
    @Binding var torchOn: Bool
    let onCodeScanned: (String) -> Void

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        if isScanning {
            uiView.startScanning()
        } else {
            uiView.stopScanning()
        }

        uiView.setTorch(on: torchOn)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeScanned: onCodeScanned)
    }

    class Coordinator: NSObject, CameraPreviewDelegate {
        let onCodeScanned: (String) -> Void

        init(onCodeScanned: @escaping (String) -> Void) {
            self.onCodeScanned = onCodeScanned
        }

        func didScanCode(_ code: String) {
            onCodeScanned(code)
        }
    }
}

// MARK: - Camera Preview Delegate

protocol CameraPreviewDelegate: AnyObject {
    func didScanCode(_ code: String)
}

// MARK: - Camera Preview UIView

class CameraPreviewUIView: UIView {
    weak var delegate: CameraPreviewDelegate?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }

    func startScanning() {
        guard captureSession == nil else {
            captureSession?.startRunning()
            return
        }

        setupCaptureSession()
    }

    func stopScanning() {
        captureSession?.stopRunning()
    }

    func setTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            Logger.error(error, message: "Failed to set torch")
        }
    }

    private func setupCaptureSession() {
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else {
            return
        }

        session.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128, .code39]
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        self.captureSession = session
        self.previewLayer = previewLayer

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CameraPreviewUIView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }

        delegate?.didScanCode(stringValue)
    }
}

// MARK: - Preview

#Preview {
    QRCodeScannerView { code in
        print("Scanned: \(code)")
    }
    .environmentObject(ToastManager())
}
