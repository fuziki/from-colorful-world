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
import InAppMessage
import SwiftUI

class MainViewModel: ObservableObject {
    public let showBadge: AnyPublisher<Bool, Never>
    @Published public var showInfomation: Bool = false
    @Published public var scanning: Bool = false
    @Published public var showAlert: Bool = false
    public let onComplete = PassthroughSubject<Void, Never>()
    public var classPeaples: Int {
        // FIXME: 40のハードコーティング
        return settingService.currentEntity.classPeaples ?? 40
    }

    private let inAppMessageService: InAppMessageService
    private let settingService: SettingService
    private let usecase: MainViewUseCase

    private let showBadgeSubject = CurrentValueSubject<Bool, Never>(false)
    private let fetchInfomation = PassthroughSubject<Void, Never>()

    private var cancellables: Set<AnyCancellable> = []
    init(usecase: MainViewUseCase,
         settingService: SettingService,
         inAppMessageService: InAppMessageService) {
        print("init MainViewModel")
        self.usecase = usecase
        self.settingService = settingService
        self.inAppMessageService = inAppMessageService

        showBadge = showBadgeSubject.eraseToAnyPublisher()
        onComplete.sink { [weak self] _ in
            self?.scanning = false
        }.store(in: &cancellables)

        setupInfomation()
    }

    private func setupInfomation() {
        fetchInfomation
            .flatMap { [weak self] _ -> AnyPublisher<Date, Never> in
                return self?.usecase
                    .fetchLatestInfomationDate(gistId: AppToken.gistId)
                    .catch { [weak self] (e: Error) -> AnyPublisher<Date, Never> in
                        print("error: \(e)")
                        // 即時実行すると表示されない事があったので少し遅らせる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                            self?.inAppMessageService.showToast(title: "最新情報の取得に失敗しました")
                        }
                        return .empty()
                    }
                    .eraseToAnyPublisher() ?? .empty()
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
        self.fetchInfomation.send(())
    }
}
