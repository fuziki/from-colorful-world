//
//  SettingViewModel.swift
//  
//
//  Created by fuziki on 2021/09/05.
//

import Foundation
import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var classPeaples: Int = 40
    private let settingService: SettingService
    init(settingService: SettingService) {
        self.settingService = settingService
        self.classPeaples = settingService.currentEntity.classPeaples ?? 40
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
