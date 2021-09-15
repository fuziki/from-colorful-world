//
//  ScanQrCodeControlPanelView.swift
//
//
//  Created by fuziki on 2021/08/31.
//

import Combine
import Foundation
import SwiftUI

struct ScanQrCodeControlPanelView: View {
    let flip: PassthroughSubject<Void, Never>
    let onComplete: PassthroughSubject<Void, Never>
    let showCurrentResult: PassthroughSubject<Void, Never>
    let isSpeakerMute: CurrentValueSubject<Bool, Never>
    let scanedConsoleText: AnyPublisher<String, Never>
    var body: some View {
        ZStack {
            scaned
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.bottom, 48)
            flipCamera
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 8)
            currentResult
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            close
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }

    private var scaned: some View {
        ScanedConsoleTextView(textPublisher: scanedConsoleText)
            .font(.system(size: 14))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .foregroundColor(.blue)
            .opacity(0.8)
    }

    private var flipCamera: some View {
        HStack(spacing: 8) {
            flipCameraButton
            beapMuteButton
        }
        .frame(height: 32, alignment: .center)
    }

    private var beapMuteButton: some View {
        MicMuteButtonView(isSpeakerMute: isSpeakerMute)
            .overlay(Capsule().stroke(lineWidth: 1))
            .background(Capsule().fill(Color.white))
            .foregroundColor(.black)
    }

    private var flipCameraButton: some View {
        Button(action: {
            print("flip")
            flip.send(())
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath.camera")
                .font(.system(size: 16))
                .frame(width: 32, height: 32, alignment: .center)
                .padding(.horizontal, 8)
        })
        .overlay(Capsule().stroke(lineWidth: 1))
        .background(Capsule().fill(Color.white))
        .foregroundColor(.black)
    }

    private var close: some View {
        Button(action: {
            onComplete.send(())
        }, label: {
            Image(systemName: "xmark")
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal, 4)
                .shadow(radius: 3)
                .shadow(color: .white, radius: 3, x: 0.0, y: 0.0)
        })
    }

    private var currentResult: some View {
        Button(action: {
            print("result")
            showCurrentResult.send(())
        }, label: {
            Text("結果を見る")
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 32, alignment: .center)
        })
        .overlay(Capsule().stroke(lineWidth: 1))
        .background(Capsule().fill(Color.white))
        .foregroundColor(.black)
    }
}

struct MicMuteButtonView: View {
    @ObservedObject private var viewModel: MicMuteButtonViewModel
    init(isSpeakerMute: CurrentValueSubject<Bool, Never>) {
        self.viewModel = MicMuteButtonViewModel(isSpeakerMute: isSpeakerMute)
    }
    var body: some View {
        Button(action: {
            viewModel.toggle()
        }, label: {
            if viewModel.isMute {
                Image(systemName: "speaker.slash")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32, alignment: .center)
                    .padding(.horizontal, 8)
            } else {
                Image(systemName: "speaker.wave.3")
                    .font(.system(size: 16))
                    .frame(width: 32, height: 32, alignment: .center)
                    .padding(.horizontal, 8)
            }
        })
    }
}

class MicMuteButtonViewModel: ObservableObject {
    @Published public var isMute: Bool
    private let isSpeakerMute: CurrentValueSubject<Bool, Never>
    init(isSpeakerMute: CurrentValueSubject<Bool, Never>) {
        isMute = isSpeakerMute.value
        self.isSpeakerMute = isSpeakerMute
    }
    public func toggle() {
        isMute = !isMute
        isSpeakerMute.send(isMute)
    }
}

struct ScanedConsoleTextView: View {
    @ObservedObject private var viewModel: ScanedConsoleTextViewModel
    init(textPublisher: AnyPublisher<String, Never>) {
        viewModel = ScanedConsoleTextViewModel(textPublisher: textPublisher)
    }
    var body: some View {
        Text(viewModel.text)
    }
}

class ScanedConsoleTextViewModel: ObservableObject {
    @Published var text: String = ""
    private var cancellables: Set<AnyCancellable> = []
    init(textPublisher: AnyPublisher<String, Never>) {
        textPublisher.sink { [weak self] (text: String) in
            self?.text = text
        }.store(in: &cancellables)
    }
}

struct ScanQrCodeControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text("ScanQrCodeView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .ignoresSafeArea()
            ScanQrCodeControlPanelView(flip: PassthroughSubject<Void, Never>(),
                                       onComplete: PassthroughSubject<Void, Never>(),
                                       showCurrentResult: PassthroughSubject<Void, Never>(),
                                       isSpeakerMute: CurrentValueSubject<Bool, Never>(false),
                                       scanedConsoleText: Just<String>("Hello\nworld").eraseToAnyPublisher())
        }
    }
}
