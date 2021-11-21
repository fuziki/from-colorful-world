//
//  Array+extensions.swift
//
//
//  Created by fuziki on 2021/11/22.
//

import Foundation

extension Array where Element: Equatable {
    public mutating func removeAll(value: Element) {
        while let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
