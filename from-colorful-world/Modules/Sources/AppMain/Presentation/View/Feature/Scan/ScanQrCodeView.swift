//
//  ScanQrCodeView.swift
//  
//
//  Created by fuziki on 2021/08/28.
//

import Combine
import Foundation
import SwiftUI

struct ScanQrCodeView: View {
    // カメラを使うので非 ObservedObject View Model だし、preview は使わない
    private var viewModel: ScanQrCodeViewModelType = ScanQrCodeViewModel()
    let onComplete: PassthroughSubject<Void, Never>
    init(onComplete: PassthroughSubject<Void, Never>) {
        self.onComplete = onComplete
    }
    var body: some View {
        ZStack {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            QrCodeDetectorView(flip: viewModel.outputs.flipCamera, detected: viewModel.inputs.onDetected)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            ScanQrCodeControlPanelView(flip: viewModel.inputs.onTapFlipCamera,
                                       onComplete: onComplete,
                                       showCurrentResult: viewModel.inputs.onTapShowCurrentResult,
                                       scanedConsoleText: viewModel.outputs.scanedConsoleText)
            CurrentResultsRootView(currentResults: viewModel.outputs.currentResults,
                                   showCurrentResults: viewModel.outputs.showCurrentResults)
        }
    }
}
