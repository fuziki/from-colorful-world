//
//  ScanQrCodeViewModel.swift
//
//
//  Created by fuziki on 2021/09/01.
//

import AVFoundation
import Combine
import Foundation

protocol ScanQrCodeViewModelInputs {
    var onDetected: PassthroughSubject<String, Never> { get }
    var onTapFlipCamera: PassthroughSubject<Void, Never> { get }
    var onTapShowCurrentResult: PassthroughSubject<Void, Never> { get }
    var isSpeakerMute: CurrentValueSubject<Bool, Never> { get }
    func onAppear()
}
protocol ScanQrCodeViewModelOutputs {
    var flipCamera: AnyPublisher<Void, Never> { get }
    var scanedConsoleText: AnyPublisher<String, Never> { get }
    var currentResults: AnyPublisher<CurrentResultsEntity, Never> { get }
    var showCurrentResults: AnyPublisher<Void, Never> { get }
}
protocol ScanQrCodeViewModelType {
    var inputs: ScanQrCodeViewModelInputs { get }
    var outputs: ScanQrCodeViewModelOutputs { get }
}
extension ScanQrCodeViewModelType where Self: ScanQrCodeViewModelInputs {
    var inputs: ScanQrCodeViewModelInputs { self }
}
extension ScanQrCodeViewModelType where Self: ScanQrCodeViewModelOutputs {
    var outputs: ScanQrCodeViewModelOutputs { self }
}

class ScanQrCodeViewModel: ScanQrCodeViewModelType,
                           ScanQrCodeViewModelInputs,
                           ScanQrCodeViewModelOutputs {
    // MARK: - Inputs
    public let onDetected = PassthroughSubject<String, Never>()
    public let onTapFlipCamera = PassthroughSubject<Void, Never>()
    public let onTapShowCurrentResult = PassthroughSubject<Void, Never>()
    public let isSpeakerMute: CurrentValueSubject<Bool, Never>

    // MARK: - Outputs
    public var flipCamera: AnyPublisher<Void, Never> {
        return onTapFlipCamera.eraseToAnyPublisher()
    }

    private let latestDetected = CurrentValueSubject<[String], Never>([])
    public var scanedConsoleText: AnyPublisher<String, Never> {
        return latestDetected
            .map { $0.joined(separator: "\n") }
            .eraseToAnyPublisher()
    }

    private let currentResultsSubject: CurrentValueSubject<CurrentResultsEntity, Never>
    public var currentResults: AnyPublisher<CurrentResultsEntity, Never> {
        return currentResultsSubject.eraseToAnyPublisher()
    }

    public var showCurrentResults: AnyPublisher<Void, Never> {
        return onTapShowCurrentResult.eraseToAnyPublisher()
    }

    // MARK: - Injected
    private let storeServcie: ScanQrCodeViewStoreServcie
    private let settingService: SettingService

    // MARK: - Properties
    private var detectedDics: [String: [Int: Bool]] = [:]
    private var classPeaples: Int

    private var audioPlayers: [AVPlayer] = {
        // TODO: Inject
        let sound = DefaultSettingService().currentEntity.feedbackSound ?? .pon
        return (0..<10).map { _ in
            let url = Bundle.module.url(forResource: sound.file, withExtension: "mp3")!
            let item = AVPlayerItem(url: url)
            return AVPlayer(playerItem: item)
        }
    }()
    private var nextPlayer: Int = 0

    private var cancellables: Set<AnyCancellable> = []
    init(storeServcie: ScanQrCodeViewStoreServcie, settingService: SettingService) {
        self.storeServcie = storeServcie
        self.settingService = settingService
        self.classPeaples = settingService.currentEntity.classPeaples ?? 40
        self.isSpeakerMute = CurrentValueSubject<Bool, Never>(storeServcie.isSpeakerMute)
        self.currentResultsSubject = CurrentValueSubject(CurrentResultsEntity(rowCount: classPeaples,
                                                                              columns: []))

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("error: \(error)")
        }

        isSpeakerMute.sink { [weak self] (isMute: Bool) in
            self?.storeServcie.update(isSpeakerMute: isMute)
        }.store(in: &cancellables)

        onDetected.sink { [weak self] (detected: String) in
            self?.detected(text: detected)
        }.store(in: &cancellables)
    }

    public func onAppear() {
        self.classPeaples = settingService.currentEntity.classPeaples ?? 40
    }

    private func detected(text: String) {
        let indexStr = text.suffix(2)
        guard let index = Int(indexStr) else { return }

        let title = String(text.prefix(text.count - 2))

        var isNew: Bool = false

        var current: [Int: Bool]? = detectedDics[title]
        if current == nil {
            isNew = true
            current = [:]
        }
        if current?[index] == nil {
            isNew = true
        }
        current?[index] = true

        if !isNew { return }

        detectedDics[title] = current

        let columns = detectedDics.map { (title: String, ok: [Int: Bool]) -> CurrentResultsColumn in
            let column = CurrentResultsColumn(title: title,
                                              ok: (1...classPeaples).map { ok[$0] ?? false })
            return column
        }

        let entity = CurrentResultsEntity(rowCount: classPeaples, columns: columns)
        currentResultsSubject.send(entity)

        var latest = latestDetected.value
        latest.append(text)
        while latest.count > 10 {
            latest.removeFirst()
        }
        latestDetected.send(latest)

        if isSpeakerMute.value { return }

        let player = audioPlayers[nextPlayer]
        player.seek(to: .zero) { (_: Bool) in
            player.play()
        }
        nextPlayer += 1
        if nextPlayer >= audioPlayers.count {
            nextPlayer = 0
        }
    }
}
