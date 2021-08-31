//
//  ScanQrCodeView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

struct ScanQrCodeView: View {
    var viewModel = ScanQrCodeViewModel()
    var body: some View {
        ZStack {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            QrCodeDetectorView(flip: viewModel.flip)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            ScanQrCodeControlPanelView(flip: viewModel._flip)
        }
    }
}

class ScanQrCodeViewModel {
    var flip: AnyPublisher<Void, Never> {
        return _flip.eraseToAnyPublisher()
    }
    let _flip = PassthroughSubject<Void, Never>()
}

struct QrCodeDetectorView: UIViewRepresentable {
    let capture: CameraCaputreService
    init(flip: AnyPublisher<Void, Never>) {
        capture = CameraCaputreService(flip: flip)
    }

    func makeUIView(context: Context) -> UIView {
        return capture.preview
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

class CameraCaputreService: NSObject {
    public let preview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    private let session = AVCaptureSession()
    private var currentPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private var useBack = true
    private var flip: AnyPublisher<Void, Never>
    
    private var capturedFrame: [UIView] = []
    
    private var cancellables: Set<AnyCancellable> = []
    init(flip: AnyPublisher<Void, Never>) {
        self.flip = flip
        super.init()
        
        startPreview()
        
        for _ in 0..<10 {
            let frame = UIView()
            frame.layer.borderWidth = 4
            frame.layer.borderColor = UIColor.red.cgColor
            preview.addSubview(frame)
            capturedFrame.append(frame)
        }
        
        flip.sink { [weak self] _ in
            self?.useBack.toggle()
            self?.startPreview()
        }.store(in: &cancellables)
    }
    
    private func startPreview() {
        print("startPreview")
        if session.isRunning {
            session.stopRunning()
        }
        session.inputs.forEach { input in
            session.removeInput(input)
        }
        session.outputs.forEach { output in
            session.removeOutput(output)
        }
        
        let position: AVCaptureDevice.Position = useBack ? .back : .front
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
        guard let device = discoverySession.devices.first else { return }
        
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error {
            print("error: \(error)")
            return
        }
        if !session.canAddInput(input) { return }
        session.addInput(input)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if !session.canAddOutput(metadataOutput) { return }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        let newPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        newPreviewLayer.videoGravity = .resizeAspectFill
        
        newPreviewLayer.frame = preview.frame
        
        if let current = self.currentPreviewLayer {
            preview.layer.replaceSublayer(current, with: newPreviewLayer)
        } else {
            preview.layer.addSublayer(newPreviewLayer)
        }
        currentPreviewLayer = newPreviewLayer
        
        preview.publisher(for: \.frame).eraseToAnyPublisher().sink { [weak self] (rect: CGRect) in
            self?.currentPreviewLayer.frame = rect
        }.store(in: &cancellables)
        
        session.startRunning()
    }
}

extension CameraCaputreService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        let metadataObjects = metadataObjects.compactMap({ $0 as? AVMetadataMachineReadableCodeObject })
        for metadata in metadataObjects {
            guard let stringValue = metadata.stringValue else { return }
            print("stringValue: \(stringValue), \(metadata.corners)")
        }
        capturedFrame.forEach { $0.isHidden = true }
        for i in 0..<min(capturedFrame.count, metadataObjects.count) {
            let metadata = metadataObjects[i]
            guard let transformed: AVMetadataObject = currentPreviewLayer?.transformedMetadataObject(for: metadata) else {
                continue
            }
            capturedFrame[i].frame = transformed.bounds
            capturedFrame[i].isHidden = false
        }
    }
}
