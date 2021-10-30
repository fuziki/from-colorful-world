//
//  MainViewModel.swift
//
//
//  Created by fuziki on 2021/09/01.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published public var scanning: Bool = false
    @Published public var showAlert: Bool = false
    public let showBadge = CurrentValueSubject<Bool, Never>(false)

    public let onComplete = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    init() {
        onComplete.sink { [weak self] _ in
            self?.scanning = false
        }.store(in: &cancellables)
        sub()
    }

    private func sub() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            print("toggle")
            self?.showBadge.send(!(self?.showBadge.value ?? true))
            self?.sub()
        }
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
}
