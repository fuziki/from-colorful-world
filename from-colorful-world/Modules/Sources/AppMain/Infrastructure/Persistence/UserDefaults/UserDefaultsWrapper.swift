//
//  UserDefaultsWrapper.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Foundation

protocol UserDefaultsWrapper {
    func store<T: Codable>(key: String, value: T)
    func fetch<T: Codable>(key: String, type: T.Type) -> T?
    func fetch<T: Codable>(key: String) -> T?
}

extension UserDefaultsWrapper {
    func fetch<T: Codable>(key: String) -> T? {
        return fetch(key: key, type: T.self)
    }
}

class DefaultUserDefaultsWrapper: UserDefaultsWrapper {
    func store<T: Codable>(key: String, value: T) {
        // swiftlint:disable force_try
        let data = try! JSONEncoder().encode(value)
        UserDefaults().set(data, forKey: key)
    }

    func fetch<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = UserDefaults().data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return value
    }
}
