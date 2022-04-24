//
//  LatestReadInfomationUseCase.swift
//
//
//  Created by fuziki on 2021/11/21.
//

import Core
import Foundation

protocol LatestReadInfomationUseCase {
    var latestDate: Date? { get }
    func read(date: Date)
}

class DefaultLatestReadInfomationUseCase: LatestReadInfomationUseCase {
    private struct Stored: Codable {
        let latestDate: Date
    }
    private let key = "factory.fuziki.from-colorful-world.DefaultLatestReadInfomationUseCase.key"
    private let userdefaults: UserDefaultsWrapper = DefaultUserDefaultsWrapper()

    public var latestDate: Date? {
        return userdefaults
            .fetch(key: key, type: Stored.self)?
            .latestDate
    }

    public func read(date: Date) {
        let stored = Stored(latestDate: date)
        userdefaults.store(key: key, value: stored)
    }
}
