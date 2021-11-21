//
//  AnyPublisher+Empty.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2021/02/01.
//

import Combine

extension AnyPublisher {
    public static func empty(completeImmediately: Bool = true) -> Self {
        return Empty(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    public static func fail(error: Self.Failure) -> Self {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
