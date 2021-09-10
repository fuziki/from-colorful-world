//
//  SettingViewModel.swift
//  
//
//  Created by fuziki on 2021/09/05.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

extension FeedbackSound {
    var display: String {
        switch self {
        case .pon: return "ポン。柔らかい音"
        case .fanfare: return "ラッパのファンファーレ"
        case .shutter: return "シャッター音"
        case .ohayo: return "おはよう"
        }
    }
}

class SettingViewModel: ObservableObject {
    @Published var classPeaples: Int = 40
    @Published var feedbackSound: FeedbackSound
    
    private let settingService: SettingService
    private var player: AVPlayer?
    
    private var cancellables: Set<AnyCancellable> = []
    init(settingService: SettingService) {
        self.settingService = settingService
        self.classPeaples = settingService.currentEntity.classPeaples ?? 40
        self.feedbackSound = settingService.currentEntity.feedbackSound ?? .pon
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("error: \(error)")
        }
        
        $feedbackSound.dropFirst().sink { [weak self] (sound: FeedbackSound) in
            guard let self = self else { return }
            let url = Bundle.module.url(forResource: sound.file, withExtension: "mp3")!
            let item = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: item)
            self.player?.play()
            var entity = self.settingService.currentEntity
            entity.feedbackSound = sound
            self.settingService.update(entity: entity)
            print("sound: \(sound)")
        }.store(in: &cancellables)
    }
    public func increment() {
        classPeaples += 1
        // TODO: 50のハードコーディングをやめる
        classPeaples = min(50, classPeaples)
        var entity = settingService.currentEntity
        entity.classPeaples = classPeaples
        settingService.update(entity: entity)
    }
    public func decrement() {
        classPeaples -= 1
        classPeaples = max(1, classPeaples)
        var entity = settingService.currentEntity
        entity.classPeaples = classPeaples
        settingService.update(entity: entity)
    }
}
