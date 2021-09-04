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
    public let rowCount: Int = 41
    @Published public var columns: [CurrentResultsColumn] = []
    
    private let currentResults: AnyPublisher<CurrentResultsEntity, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    init(currentResults: AnyPublisher<CurrentResultsEntity, Never>) {
        self.currentResults = currentResults
        self.currentResults.sink { [weak self] (entity: CurrentResultsEntity) in
            self?.columns = entity.columns
        }.store(in: &cancellables)
    }
}
