//
//  SettingViewModel.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Assets
import AVFoundation
import Combine
import Foundation
import SafariServices
import SwiftUI
import UIKit

extension FeedbackSound {
    var display: String {
        switch self {
        case .pon: return "ポン。柔らかい音"
        case .fanfare: return "ラッパのファンファーレ"
        case .shutter: return "シャッター音"
        case .ohayo: return "おはよう"
        case .recoded: return "データを記録しました"
        }
    }
    var url: URL {
        switch self {
        case .pon: return Files.Audio.Se.ponMp3.url
        case .fanfare: return Files.Audio.Se.fanfareMp3.url
        case .shutter: return Files.Audio.Se.shutterMp3.url
        case .ohayo: return Files.Audio.Se.ohayoMp3.url
        case .recoded: return Files.Audio.Se.recodedMp3.url
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
            let url = sound.url
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

    public func tapContactUs() {
        var systemInfo = utsname()
        uname(&systemInfo)
        let ascii = NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.utf8.rawValue)
        let model = ascii?.utf8String.flatMap { String(validatingUTF8: $0) } ?? "Model"
        let sysytem = UIDevice.current.systemVersion
        let env = "\(model.replacingOccurrences(of: ",", with: "%2C"))(\(sysytem))"
        guard let url = URL(string: "https://docs.google.com/forms/d/e/\(AppToken.contactUsFormId)/viewform?usp=pp_url&entry.\(AppToken.contactUsEntryId)=\(env)") else { return }
        if let root = getRootViewController() {
            let vc = SFSafariViewController(url: url)
            root.present(vc, animated: true, completion: nil)
        } else if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    public func tapShare() {
        guard let url = URL(string: "https://apps.apple.com/jp/app/id\(AppToken.appAppleId)") else { return }
        let activityItems: [Any] = [url]
        let vc = UIActivityViewController(activityItems: activityItems,
                                          applicationActivities: nil)
        guard let rootVC = getRootViewController() else { return }

        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = rootVC.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: rootVC.view.frame.width / 2,
                                                                  y: 128,
                                                                  width: 1,
                                                                  height: 1)
        }
        DispatchQueue.main.async {
            rootVC.present(vc, animated: true, completion: nil)
        }
    }

    public func tapReviewThisApp() {
        guard let url = URL(string: "https://itunes.apple.com/app/id\(AppToken.appAppleId)?action=write-review") else { return }
        UIApplication.shared.open(url)
    }

    private func getRootViewController() -> UIViewController? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
    }
}
