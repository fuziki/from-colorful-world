//
//  Publisher+extensions.swift
//
//
//  Created by fuziki on 2021/11/22.
//

import Combine
import Foundation

extension Publisher {
    public func filterNil<T>() -> AnyPublisher<T, Failure> where Output == T? {
        return compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
