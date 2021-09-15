//
//  CurrentResultsRootViewModel.swift
//
//
//  Created by fuziki on 2021/09/01.
//

import Combine
import Foundation
import SwiftUI

class CurrentResultsRootViewModel: ObservableObject {
    @Published var show: Bool = false

    public let currentResults: AnyPublisher<CurrentResultsEntity, Never>
    private let showCurrentResults: AnyPublisher<Void, Never>

    private var cancellables: Set<AnyCancellable> = []
    init(currentResults: AnyPublisher<CurrentResultsEntity, Never>, showCurrentResults: AnyPublisher<Void, Never>) {
        self.currentResults = currentResults
        self.showCurrentResults = showCurrentResults
        self.showCurrentResults.sink { [weak self] _ in
            self?.show = true
        }.store(in: &cancellables)
    }
}
