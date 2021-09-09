//
//  MakeNewQrCodeViewModel.swift
//  
//
//  Created by fuziki on 2021/09/09.
//

import Combine
import Foundation
import SwiftUI

class MakeNewQrCodeViewModel: ObservableObject {
    @Published var qrcodeCount: Int
    private let settingService: SettingService
    init(settingService: SettingService) {
        self.settingService = settingService
        self.qrcodeCount = settingService.currentEntity.classPeaples ?? 40
    }
    public func onAppear() {
        self.qrcodeCount = settingService.currentEntity.classPeaples ?? 40
    }
    public func increment() {
        qrcodeCount = min(50, qrcodeCount + 1)
    }
    public func decrement() {
        qrcodeCount = max(1, qrcodeCount - 1)
    }
}
