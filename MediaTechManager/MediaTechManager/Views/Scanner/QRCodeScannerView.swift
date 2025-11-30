//
//  QRCodeScannerView.swift
//  MediaTechManager
//
//  Erweiterter QR-Code Scanner für Inventarisierung, Verleih und Rückgabe
//

import SwiftUI
import AVFoundation
import SwiftData

// MARK: - Scan Mode

enum QRScanMode: String, CaseIterable {
    case single = "Einzelscan"
    case batch = "Mehrfachscan"
    case checkout = "Ausleihe"
    case checkin = "Rückgabe"
    case inventory = "Inventur"
    
    var icon: String {
        switch self {
        case .single: return "qrcode.viewfinder"
        case .batch: return "square.stack.3d.up"
        case .checkout: return "arrow.up.forward.circle"
        case .checkin: return "arrow.down.backward.circle"
        case .inventory: return "checklist"
        }
    }
    
    var description: String {
        switch self {
        case .single: return "Ein Gerät scannen"
        case .batch: return "Mehrere Geräte scannen"
        case .checkout: return "Geräte für Ausleihe erfassen"
        case .checkin: return "Geräte zurückgeben"
        case .inventory: return "Bestand prüfen"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .single: return .brandPrimary
        case .batch: return .purple
        case .checkout: return .orange
        case .checkin: return .green
        case .inventory: return .cyan
        }
    }
}

// MARK: - Scan Result

struct QRScanResult: Identifiable, Equatable {
    let id = UUID()
    let code: String
    let equipment: Equipment?
    let timestamp: Date
    let isValid: Bool
    
    var displayName: String {
        equipment?.displayName ?? code
    }
    
    static func == (lhs: QRScanResult, rhs: QRScanResult) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - QR Code Scanner View

struct QRCodeScannerView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var toastManager: ToastManager

    // MARK: - Properties

    let mode: QRScanMode
    let onScan: (String) -> Void
    let onBatchComplete: (([QRScanResult]) -> Void)?

    // MARK: - State

    @State private var isScanning = true
    @State private var scannedCode: String?
    @State private var torchOn = false
    @State private var showPermissionDenied = false
    @State private var scannedResults: [QRScanResult] = []
    @State private var lastScannedCode: String?
    @State private var showResultSheet = false
    @State private var currentResult: QRScanResult?
    @State private var scanFeedback: ScanFeedback = .none
    
    // MARK: - Initializers
    
    init(
        mode: QRScanMode = .single,
        onScan: @escaping (String) -> Void,
        onBatchComplete: (([QRScanResult]) -> Void)? = nil
    ) {
        self.mode = mode
        self.onScan = onScan
        self.onBatchComplete = onBatchComplete
    }

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
                
                // Scan Feedback Animation
                scanFeedbackOverlay

                // Permission Denied
                if showPermissionDenied {
                    permissionDeniedView
                }
                
                // Batch Mode Bottom Sheet
                if mode == .batch || mode == .checkout || mode == .inventory {
                    batchResultsOverlay
                }
            }
            .navigationTitle(mode.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { 
                        if !scannedResults.isEmpty {
                            onBatchComplete?(scannedResults)
                        }
                        dismiss() 
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    HStack(spacing: Spacing.sm) {
                        if mode == .batch || mode == .checkout || mode == .inventory {
                            Button {
                                onBatchComplete?(scannedResults)
                                dismiss()
                            } label: {
                                Text("Fertig (\(scannedResults.count))")
                                    .fontWeight(.semibold)
                            }
                            .disabled(scannedResults.isEmpty)
                        }
                        
                        Button {
                            torchOn.toggle()
                        } label: {
                            Image(systemName: torchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        }
                    }
                }
            }
            .onAppear {
                checkCameraPermission()
            }
            .sheet(isPresented: $showResultSheet) {
                if let result = currentResult {
                    ScanResultDetailSheet(
                        result: result,
                        mode: mode,
                        onAction: handleResultAction
                    )
                    .presentationDetents([.medium])
                }
            }
        }
    }

    // MARK: - Scanner Overlay

    private var scannerOverlay: some View {
        VStack {
            // Mode Info Header
            VStack(spacing: Spacing.xs) {
                HStack {
                    Image(systemName: mode.icon)
                    Text(mode.description)
                }
                .font(.bodyMedium)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(mode.accentColor.opacity(0.8))
                .clipShape(Capsule())
            }
            .padding(.top, Spacing.lg)

            Spacer()

            // Scan Frame
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    .frame(width: 280, height: 280)

                // Corner Accents
                ScannerCorners()
                    .stroke(mode.accentColor, lineWidth: 4)
                    .frame(width: 280, height: 280)
                
                // Scanning Line Animation
                if isScanning {
                    ScanningLineView(color: mode.accentColor)
                }
            }

            Spacer()

            // Instructions
            VStack(spacing: Spacing.sm) {
                Text("QR-Code in den Rahmen halten")
                    .font(.bodyLarge)
                    .foregroundStyle(.white)

                Text(instructionText)
                    .font(.bodySmall)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, mode == .batch || mode == .checkout || mode == .inventory ? 180 : Spacing.xxxl)
        }
    }
    
    private var instructionText: String {
        switch mode {
        case .single:
            return "Der Code wird automatisch erkannt"
        case .batch:
            return "Scannen Sie mehrere Geräte nacheinander"
        case .checkout:
            return "Scannen Sie alle Geräte für die Ausleihe"
        case .checkin:
            return "Scannen Sie das Gerät zur Rückgabe"
        case .inventory:
            return "Scannen Sie Geräte zur Bestandsprüfung"
        }
    }
    
    // MARK: - Scan Feedback Overlay
    
    private var scanFeedbackOverlay: some View {
        Group {
            if scanFeedback != .none {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: scanFeedback.icon)
                        Text(scanFeedback.message)
                    }
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(Spacing.md)
                    .background(scanFeedback.color)
                    .clipShape(Capsule())
                    .transition(.scale.combined(with: .opacity))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(scanFeedback.color.opacity(0.2))
            }
        }
        .animation(.spring(duration: 0.3), value: scanFeedback)
    }
    
    // MARK: - Batch Results Overlay
    
    private var batchResultsOverlay: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Gescannte Geräte")
                        .font(.titleMedium)
                    
                    Spacer()
                    
                    Text("\(scannedResults.count)")
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundStyle(mode.accentColor)
                }
                .padding(Spacing.md)
                .background(Color.backgroundPrimary)
                
                Divider()
                
                // Results List
                if scannedResults.isEmpty {
                    VStack(spacing: Spacing.sm) {
                        Image(systemName: "qrcode")
                            .font(.system(size: 32))
                            .foregroundStyle(.secondary)
                        Text("Noch keine Geräte gescannt")
                            .font(.bodyMedium)
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.sm) {
                            ForEach(scannedResults) { result in
                                ScannedItemChip(
                                    result: result,
                                    accentColor: mode.accentColor,
                                    onRemove: { removeResult(result) },
                                    onTap: { showResultDetail(result) }
                                )
                            }
                        }
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                    }
                    .frame(height: 80)
                }
            }
            .background(Color.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
            .shadow(color: .black.opacity(0.2), radius: 10, y: -5)
            .padding(.horizontal, Spacing.sm)
            .padding(.bottom, Spacing.sm)
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
        // Prevent duplicate rapid scans
        guard code != lastScannedCode else { return }
        lastScannedCode = code
        
        // Reset after delay to allow re-scanning same code
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if lastScannedCode == code {
                lastScannedCode = nil
            }
        }
        
        // Parse QR Code
        let parsedContent = QRCodeService.parseQRContent(code)
        var equipment: Equipment?
        var isValid = false
        
        if let content = parsedContent {
            switch content {
            case .equipment(let inventoryNumber):
                equipment = findEquipment(byInventoryNumber: inventoryNumber)
                isValid = equipment != nil
            case .equipmentById(let id):
                equipment = findEquipment(byId: id)
                isValid = equipment != nil
            case .rental:
                // Handle rental codes differently
                isValid = true
            }
        }
        
        // Create result
        let result = QRScanResult(
            code: code,
            equipment: equipment,
            timestamp: Date(),
            isValid: isValid
        )
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        
        switch mode {
        case .single:
            if isValid {
                generator.notificationOccurred(.success)
                showFeedback(.success)
                isScanning = false
                onScan(code)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            } else {
                generator.notificationOccurred(.error)
                showFeedback(.invalid)
            }
            
        case .batch, .checkout, .inventory:
            // Check if already scanned
            if scannedResults.contains(where: { $0.code == code }) {
                generator.notificationOccurred(.warning)
                showFeedback(.duplicate)
            } else if isValid {
                generator.notificationOccurred(.success)
                showFeedback(.success)
                scannedResults.append(result)
                onScan(code)
            } else {
                generator.notificationOccurred(.error)
                showFeedback(.invalid)
            }
            
        case .checkin:
            if isValid {
                generator.notificationOccurred(.success)
                showFeedback(.success)
                currentResult = result
                isScanning = false
                showResultSheet = true
            } else {
                generator.notificationOccurred(.error)
                showFeedback(.invalid)
            }
        }
    }
    
    private func showFeedback(_ feedback: ScanFeedback) {
        scanFeedback = feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            scanFeedback = .none
        }
    }
    
    private func findEquipment(byInventoryNumber inventoryNumber: String) -> Equipment? {
        let descriptor = FetchDescriptor<Equipment>(
            predicate: #Predicate { $0.inventoryNumber == inventoryNumber }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    private func findEquipment(byId id: String) -> Equipment? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        let descriptor = FetchDescriptor<Equipment>(
            predicate: #Predicate { $0.id == uuid }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    private func removeResult(_ result: QRScanResult) {
        scannedResults.removeAll { $0.id == result.id }
        HapticManager.light()
    }
    
    private func showResultDetail(_ result: QRScanResult) {
        currentResult = result
        showResultSheet = true
    }
    
    private func handleResultAction(_ action: ScanResultAction) {
        showResultSheet = false
        
        switch action {
        case .dismiss:
            break
        case .continueScanning:
            isScanning = true
        case .viewDetails:
            // Handle navigation to equipment details
            break
        case .startRental:
            // Handle starting rental
            break
        case .returnEquipment:
            if let equipment = currentResult?.equipment {
                equipment.isAvailable = true
                equipment.touch()
                try? modelContext.save()
                toastManager.success("\(equipment.displayName) zurückgegeben")
            }
            dismiss()
        }
    }
}

// MARK: - Scan Feedback

enum ScanFeedback: Equatable {
    case none
    case success
    case duplicate
    case invalid
    
    var icon: String {
        switch self {
        case .none: return ""
        case .success: return "checkmark.circle.fill"
        case .duplicate: return "exclamationmark.triangle.fill"
        case .invalid: return "xmark.circle.fill"
        }
    }
    
    var message: String {
        switch self {
        case .none: return ""
        case .success: return "Erfolgreich gescannt"
        case .duplicate: return "Bereits gescannt"
        case .invalid: return "Ungültiger Code"
        }
    }
    
    var color: Color {
        switch self {
        case .none: return .clear
        case .success: return .green
        case .duplicate: return .orange
        case .invalid: return .red
        }
    }
}

// MARK: - Scan Result Action

enum ScanResultAction {
    case dismiss
    case continueScanning
    case viewDetails
    case startRental
    case returnEquipment
}

// MARK: - Scanning Line View

struct ScanningLineView: View {
    let color: Color
    @State private var offset: CGFloat = -130
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [color.opacity(0), color, color.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 3)
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    offset = 130
                }
            }
    }
}

// MARK: - Scanned Item Chip

struct ScannedItemChip: View {
    let result: QRScanResult
    let accentColor: Color
    let onRemove: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.xs) {
                if let equipment = result.equipment {
                    if let imageData = equipment.primaryImage,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(accentColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay {
                                Image(systemName: "shippingbox.fill")
                                    .foregroundStyle(accentColor)
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(result.displayName)
                        .font(.labelMedium)
                        .lineLimit(1)
                    
                    if let equipment = result.equipment {
                        Text(equipment.inventoryNumber)
                            .font(.labelSmall)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(Color.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusMedium))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Scan Result Detail Sheet

struct ScanResultDetailSheet: View {
    let result: QRScanResult
    let mode: QRScanMode
    let onAction: (ScanResultAction) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                // Equipment Info
                if let equipment = result.equipment {
                    VStack(spacing: Spacing.md) {
                        // Image
                        if let imageData = equipment.primaryImage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
                        } else {
                            RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge)
                                .fill(Color.backgroundSecondary)
                                .frame(width: 120, height: 120)
                                .overlay {
                                    Image(systemName: "shippingbox.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.secondary)
                                }
                        }
                        
                        VStack(spacing: Spacing.xs) {
                            Text(equipment.displayName)
                                .font(.titleLarge)
                            
                            Text(equipment.inventoryNumber)
                                .font(.bodyMedium)
                                .foregroundStyle(.secondary)
                            
                            // Status Badge
                            AvailabilityBadge(isAvailable: equipment.isAvailable)
                        }
                    }
                    
                    Divider()
                    
                    // Details
                    VStack(spacing: Spacing.sm) {
                        if let category = equipment.category {
                            DetailInfoRow(label: "Kategorie", value: category.name)
                        }
                        if let location = equipment.location {
                            DetailInfoRow(label: "Standort", value: location.name)
                        }
                        if let condition = equipment.condition {
                            DetailInfoRow(label: "Zustand", value: condition.name)
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                } else {
                    // Unknown code
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.orange)
                        
                        Text("Unbekannter Code")
                            .font(.titleLarge)
                        
                        Text(result.code)
                            .font(.monoSmall)
                            .foregroundStyle(.secondary)
                            .padding(Spacing.sm)
                            .background(Color.backgroundSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusSmall))
                    }
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: Spacing.sm) {
                    if result.equipment != nil {
                        switch mode {
                        case .checkin:
                            PrimaryButton("Gerät zurückgeben", icon: "checkmark.circle") {
                                onAction(.returnEquipment)
                            }
                        case .checkout:
                            PrimaryButton("Zur Ausleihe hinzufügen", icon: "plus.circle") {
                                onAction(.startRental)
                            }
                        default:
                            PrimaryButton("Details anzeigen", icon: "info.circle") {
                                onAction(.viewDetails)
                            }
                        }
                    }
                    
                    SecondaryButton("Weiter scannen", icon: "qrcode.viewfinder") {
                        onAction(.continueScanning)
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.lg)
            }
            .padding(.top, Spacing.lg)
            .navigationTitle("Scan-Ergebnis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") {
                        onAction(.dismiss)
                    }
                }
            }
        }
    }
}

// MARK: - Detail Info Row

struct DetailInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.bodyMedium)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.bodyMedium)
        }
    }
}

// MARK: - Scanner Corners Shape

struct ScannerCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = 40

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
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession?.startRunning()
            }
            return
        }

        setupCaptureSession()
    }

    func stopScanning() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
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
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128, .code39, .dataMatrix]
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
    QRCodeScannerView(mode: .batch) { code in
        print("Scanned: \(code)")
    } onBatchComplete: { results in
        print("Batch complete: \(results.count) items")
    }
    .environmentObject(ToastManager())
}
