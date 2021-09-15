//
//  SettingService.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Foundation

enum FeedbackSound: String, Codable, CaseIterable {
    case pon
    case shutter
    case fanfare
    case ohayo
    case recoded
    var file: String {
        return self.rawValue
    }
}

struct SettingEntity: Codable {
    // 追加するときはオプショナル型にする
    var classPeaples: Int?
    var feedbackSound: FeedbackSound?
    static var `default`: SettingEntity {
        SettingEntity(classPeaples: nil, feedbackSound: nil)
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
