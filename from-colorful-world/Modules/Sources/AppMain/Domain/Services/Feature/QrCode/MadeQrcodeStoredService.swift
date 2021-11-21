//
//  File.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import AppleExtensions
import Foundation

protocol MadeQrcodeStoredService {
    var list: [String] { get }
    func store(title: String)
}

class DefaultMadeQrcodeStoredService: MadeQrcodeStoredService {
    let key = "factory.fuziki.from-colorful-world.MadeQrcodeStoredService.key"
    let userDefaults: UserDefaultsWrapper = DefaultUserDefaultsWrapper()
    var list: [String] {
        return userDefaults.fetch(key: key, type: [String].self) ?? []
    }
    func store(title: String) {
        var current: [String] = userDefaults.fetch(key: key, type: [String].self) ?? []
        current.removeAll(value: title)
        current.append(title)
        // TODO: 設定に
        while current.count > 100 {
            current.removeFirst()
        }
        userDefaults.store(key: key, value: current)
    }
}
