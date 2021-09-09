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
    public let onDetected = PassthroughSubject<String, Never>()
    public let onTapFlipCamera = PassthroughSubject<Void, Never>()
    public let onTapShowCurrentResult = PassthroughSubject<Void, Never>()
    public let isSpeakerMute = CurrentValueSubject<Bool, Never>(true)
    
    public var flipCamera: AnyPublisher<Void, Never> {
        return onTapFlipCamera.eraseToAnyPublisher()
    }
    
    private let latestDetected = CurrentValueSubject<[String], Never>([])
    public var scanedConsoleText: AnyPublisher<String, Never> {
        return latestDetected
            .map { $0.joined(separator: "\n") }
            .eraseToAnyPublisher()
    }
    
    private let currentResultsSubject = CurrentValueSubject<CurrentResultsEntity, Never>(.default)
    public var currentResults: AnyPublisher<CurrentResultsEntity, Never> {
        return currentResultsSubject.eraseToAnyPublisher()
    }

    public var showCurrentResults: AnyPublisher<Void, Never> {
        return onTapShowCurrentResult.eraseToAnyPublisher()
    }
    
    private var detectedDics: [String: [Int: Bool]] = [:]
    
    private var audioPlayers: [AVPlayer] = {
        return (0..<6).map { _ in
            let url = Bundle.module.url(forResource: "pon", withExtension: "mp3")!
            let item = AVPlayerItem(url: url)
            return AVPlayer(playerItem: item)
        }
    }()
    private var nextPlayer: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("error: \(error)")
        }

        onDetected.sink { [weak self] (detected: String) in
            self?.detected(text: detected)
        }.store(in: &cancellables)
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
        
        let columns = detectedDics.map { (title: String, ok: [Int : Bool]) -> CurrentResultsColumn in
            let column = CurrentResultsColumn(title: title,
                                              ok: (1...40).map { ok[$0] ?? false } )
            return column
        }

        let entity = CurrentResultsEntity(columns: columns)
        currentResultsSubject.send(entity)
        
        var latest = latestDetected.value
        latest.append(text)
        while latest.count > 10 {
            latest.removeFirst()
        }
        latestDetected.send(latest)
        
        if isSpeakerMute.value { return }
        
        let player = audioPlayers[nextPlayer]
        player.pause()
        player.seek(to: .zero) { (_: Bool) in
            player.play()
        }
        nextPlayer += 1
        if nextPlayer >= audioPlayers.count {
            nextPlayer = 0
        }
    }
}
