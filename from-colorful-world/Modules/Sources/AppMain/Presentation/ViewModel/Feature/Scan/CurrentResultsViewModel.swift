//
//  File.swift
//
//
//  Created by fuziki on 2021/09/04.
//

import Combine
import Foundation

protocol CurrentResultsViewModelInputs {
}
protocol CurrentResultsViewModelOutputs {
    var rowCount: Int { get }
    var columns: [CurrentResultsColumn] { get }
}
protocol CurrentResultsViewModelType: ObservableObject {
    var inputs: CurrentResultsViewModelInputs { get }
    var outputs: CurrentResultsViewModelOutputs { get }
}
extension CurrentResultsViewModelType where Self: CurrentResultsViewModelInputs {
    var inputs: CurrentResultsViewModelInputs { self }
}
extension CurrentResultsViewModelType where Self: CurrentResultsViewModelOutputs {
    var outputs: CurrentResultsViewModelOutputs { self }
}

class CurrentResultsViewModel: CurrentResultsViewModelType,
                               CurrentResultsViewModelInputs,
                               CurrentResultsViewModelOutputs {
    private static let defaultRowCount: Int = 41
    @Published public var rowCount: Int
    @Published public var columns: [CurrentResultsColumn] = []

    private let currentResults: AnyPublisher<CurrentResultsEntity, Never>

    private var cancellables: Set<AnyCancellable> = []
    init(currentResults: AnyPublisher<CurrentResultsEntity, Never>) {
        self.currentResults = currentResults
        self.rowCount = Self.defaultRowCount
        self.currentResults.sink { [weak self] (entity: CurrentResultsEntity) in
            // タイトルがあるので、クラス人数+1の行を用意する
            self?.rowCount = entity.rowCount + 1
            self?.columns = entity.columns
        }.store(in: &cancellables)
    }
}
