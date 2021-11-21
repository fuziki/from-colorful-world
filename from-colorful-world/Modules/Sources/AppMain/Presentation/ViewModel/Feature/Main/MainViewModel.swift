//
//  MainViewModel.swift
//
//
//  Created by fuziki on 2021/09/01.
//

import Assets
import AVFoundation
import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    public let showBadge: AnyPublisher<Bool, Never>
    @Published public var showInfomation: Bool = false
    @Published public var scanning: Bool = false
    @Published public var showAlert: Bool = false
    public let onComplete = PassthroughSubject<Void, Never>()
    
    private let usecase: MainViewUseCase

    private let showBadgeSubject = CurrentValueSubject<Bool, Never>(false)
    private let fetchInfomation = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    init(usecase: MainViewUseCase) {
        print("init MainViewModel")
        self.usecase = usecase
        showBadge = showBadgeSubject.share().eraseToAnyPublisher()
        onComplete.sink { [weak self] _ in
            self?.scanning = false
        }.store(in: &cancellables)
        
        fetchInfomation
            .flatMap { [weak self] _ -> AnyPublisher<Date, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.usecase
                    .fetchLatestInfomationDate(gistId: AppToken.gistId)
            }
            .catch { (e: Error) -> AnyPublisher<Date, Never> in
                print("error: \(e)")
                return Empty().eraseToAnyPublisher()
            }
            .sink { [weak self] (date: Date) in
                print("latest: \(date)")
                let latest = self?.usecase.latestReadInfomationDate
                if let l = latest {
                    self?.showBadgeSubject.send(date > l)
                } else {
                    self?.showBadgeSubject.send(true)
                }
            }
            .store(in: &cancellables)
    }
    
    public func tapInfomation() {
        showInfomation = true
        showBadgeSubject.send(false)
    }

    public func startScan() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            scanning = true

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.scanning = true
                    } else {
                        self?.showAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showAlert = true
        @unknown default:
            return
        }
    }

    public func onAppear() {
        fetchInfomation.send(())
    }
}
