//
//  UserDefaultsWrapper.swift
//
//
//  Created by fuziki on 2021/09/05.
//

import Foundation

public protocol UserDefaultsWrapper {
    func store<T: Codable>(key: String, value: T)
    func fetch<T: Codable>(key: String, type: T.Type) -> T?
    func fetch<T: Codable>(key: String) -> T?
}

extension UserDefaultsWrapper {
    public func fetch<T: Codable>(key: String) -> T? {
        return fetch(key: key, type: T.self)
    }
}

public class DefaultUserDefaultsWrapper: UserDefaultsWrapper {
    public init() {
    }

    public func store<T: Codable>(key: String, value: T) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults().set(data, forKey: key)
        } catch let error {
            print("failed store error: \(error)")
        }
    }

    public func fetch<T: Codable>(key: String, type: T.Type) -> T? {
        guard let data = UserDefaults().data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return value
    }
}
