//
//  SettingService.swift
//  
//
//  Created by fuziki on 2021/09/05.
//

import Foundation

struct SettingEntity: Codable {
    // 追加するときはオプショナル型にする
    var classPeaples: Int?
    static var `default`: SettingEntity {
        SettingEntity(classPeaples: nil)
    }
}

protocol SettingService {
    var currentEntity: SettingEntity { get }
    func update(entity: SettingEntity)
}

class DefaultSettingService: SettingService {
    private let key = "project.shannon.from-colorful-world.DefaultSettingService.key"
    private let userdefaults: UserDefaultsWrapper = DefaultUserDefaultsWrapper()
    
    public var currentEntity: SettingEntity {
        return userdefaults.fetch(key: key) ?? .default
    }

    public func update(entity: SettingEntity) {
        userdefaults.store(key: key, value: entity)
    }
}
