//
//  ScanQrCodeView.swift
//
//
//  Created by fuziki on 2021/08/28.
//

import Combine
import Core
import Foundation
import LookBack
import QRCode
import Setting
import SwiftUI

struct ScanQrCodeView: View {
    // カメラを使うので非 ObservedObject View Model だし、preview は使わない
    private let viewModel: ScanQrCodeViewModelType
    let onComplete: PassthroughSubject<Void, Never>
    init(onComplete: PassthroughSubject<Void, Never>) {
        self.onComplete = onComplete
        viewModel = ScanQrCodeViewModel(storeServcie: DefaultScanQrCodeViewStoreServcie(),
                                        settingService: DefaultSettingService.shared,
                                        lookBackWriteUseCase: LookBackUseCase(fileManager: DefaultFileManagerWrapper()))
    }
    var body: some View {
        ZStack {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            QrCodeDetectorView(flip: viewModel.outputs.flipCamera, detected: viewModel.inputs.onDetected)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack {
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .black.opacity(0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .frame(height: 128)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
            ScanQrCodeControlPanelView(flip: viewModel.inputs.onTapFlipCamera,
                                       onComplete: onComplete,
                                       showCurrentResult: viewModel.inputs.onTapShowCurrentResult,
                                       isSpeakerMute: viewModel.inputs.isSpeakerMute,
                                       scanedConsoleText: viewModel.outputs.scanedConsoleText)
            CurrentResultsRootView(currentResults: viewModel.outputs.currentResults,
                                   showCurrentResults: viewModel.outputs.showCurrentResults)
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            viewModel.inputs.onAppear()
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            viewModel.inputs.onDisappear()
        }
    }
}
