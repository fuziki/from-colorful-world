//
//  ScanQrCodeViewModel.swift
//  
//
//  Created by fuziki on 2021/09/01.
//

import Combine
import Foundation

protocol ScanQrCodeViewModelInputs {
    var onDetected: PassthroughSubject<String, Never> { get }
    var onTapFlipCamera: PassthroughSubject<Void, Never> { get }
    var onTapShowCurrentResult: PassthroughSubject<Void, Never> { get }
}
protocol ScanQrCodeViewModelOutputs {
    var flipCamera: AnyPublisher<Void, Never> { get }
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
    
    public var flipCamera: AnyPublisher<Void, Never> {
        return onTapFlipCamera.eraseToAnyPublisher()
    }
    
    private let currentResultsSubject = CurrentValueSubject<CurrentResultsEntity, Never>(.init(title: "init"))
    public var currentResults: AnyPublisher<CurrentResultsEntity, Never> {
        return currentResultsSubject.eraseToAnyPublisher()
    }

    public var showCurrentResults: AnyPublisher<Void, Never> {
        return onTapShowCurrentResult.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    init() {
    }
}
