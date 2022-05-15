//
//  SettingService.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Combine
import Core
import Foundation

public enum FeedbackSound: String, Codable, CaseIterable {
    case pon
    case shutter
    case fanfare
    case ohayo
    case recoded
}

public struct SettingEntity: Codable {
    // 追加するときはオプショナル型にする
    public var classPeaples: Int?
    public var feedbackSound: FeedbackSound?
    public var enableLookBack: Bool?
    static var `default`: SettingEntity {
        SettingEntity(classPeaples: nil, feedbackSound: nil, enableLookBack: nil)
    }
}

/// @mockable
public protocol SettingService {
    var currentEntity: SettingEntity { get }
    var entityPublisher: AnyPublisher<SettingEntity, Never> { get }
    func update(entity: SettingEntity)
}

public class DefaultSettingService: SettingService {
    private static let key = "project.shannon.from-colorful-world.DefaultSettingService.key"
    private let userdefaults: UserDefaultsWrapper = DefaultUserDefaultsWrapper()

    public static let shared: SettingService = DefaultSettingService()

    private let entitySubject: CurrentValueSubject<SettingEntity, Never>

    private var cancellables: Set<AnyCancellable> = []
    private init() {
        let latest: SettingEntity = userdefaults.fetch(key: Self.key) ?? .default
        entitySubject = .init(latest)
        entitySubject
            .dropFirst()
            .sink { [weak self] (entity: SettingEntity) in
                self?.userdefaults.store(key: Self.key, value: entity)
            }
            .store(in: &cancellables)
    }

    public var currentEntity: SettingEntity {
        return entitySubject.value
    }

    public var entityPublisher: AnyPublisher<SettingEntity, Never> {
        return entitySubject.eraseToAnyPublisher()
    }

    public func update(entity: SettingEntity) {
        entitySubject.send(entity)
    }
}
