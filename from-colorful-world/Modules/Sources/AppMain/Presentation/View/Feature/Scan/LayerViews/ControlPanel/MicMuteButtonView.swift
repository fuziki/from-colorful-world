//
//  File.swift
//
//
//  Created by fuziki on 2022/03/13.
//

import Combine
import Foundation
import SwiftUI

struct MicMuteButtonView: View {
    @ObservedObject private var viewModel: MicMuteButtonViewModel
    init(isSpeakerMute: CurrentValueSubject<Bool, Never>) {
        self.viewModel = MicMuteButtonViewModel(isSpeakerMute: isSpeakerMute)
    }
    var body: some View {
        Button {
            viewModel.toggle()
        } label: {
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
        }
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
