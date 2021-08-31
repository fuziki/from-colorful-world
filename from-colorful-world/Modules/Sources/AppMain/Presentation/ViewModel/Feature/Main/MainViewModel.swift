//
//  MainViewModel.swift
//  
//
//  Created by fuziki on 2021/09/01.
//

import Combine
import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published public var scanning: Bool = false
    public let onComplete = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    init() {
        onComplete.sink { [weak self] _ in
            self?.scanning = false
        }.store(in: &cancellables)
    }
    public func startScan() {
        scanning = true
    }
}
