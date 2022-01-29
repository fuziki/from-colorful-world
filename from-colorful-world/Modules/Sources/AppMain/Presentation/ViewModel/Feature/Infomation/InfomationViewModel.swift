//
//  InfomationViewModel.swift
//
//
//  Created by fuziki on 2021/11/21.
//

import Assets
import Core
import Combine
import Foundation
import SwiftUI
import CombineSchedulers

protocol InfomationViewModelInputs {
    func onAppear()
    func onRefresh()
}
protocol InfomationViewModelOutputs {
    var isLoading: Bool { get }
    var cellEntities: [InfomationViewCellEntity] { get }
}
protocol InfomationViewModelType: ObservableObject {
    var inputs: InfomationViewModelInputs { get }
    var outputs: InfomationViewModelOutputs { get }
}
extension InfomationViewModelType where Self: InfomationViewModelInputs {
    var inputs: InfomationViewModelInputs { self }
}
extension InfomationViewModelType where Self: InfomationViewModelOutputs {
    var outputs: InfomationViewModelOutputs { self }
}

class InfomationViewModel: InfomationViewModelType,
                           InfomationViewModelInputs,
                           InfomationViewModelOutputs {
    @Published public var isLoading: Bool = false
    @Published public var cellEntities: [InfomationViewCellEntity] = []

    private let usecase: InfomationViewUseCase
    private let scheduler: AnySchedulerOf<RunLoop>

    private let fetch = PassthroughSubject<Void, Never>()

    private var cancellables: Set<AnyCancellable> = []
    init(usecase: InfomationViewUseCase, scheduler: AnySchedulerOf<RunLoop>) {
        self.usecase = usecase
        self.scheduler = scheduler
        self.setupFetch()
    }

    private func setupFetch() {
        fetch
            .flatMap { [weak self] _ -> AnyPublisher<InformationApi.Response, Never> in
                guard let self = self else { return .empty() }
                return self.usecase
                    .fetch(gistId: AppToken.gistId)
                    .catch { (e: Error) -> AnyPublisher<InformationApi.Response, Never> in
                        print("error: \(e)")
                        return .empty()
                    }
                    .eraseToAnyPublisher()
            }
            .map { (response: InformationApi.Response) in
                return response
                    .information
                    .compactMap { (info: InformationApi.Response.Information) -> InfomationViewCellEntity? in
                        guard let title = info.title["ja"],
                              let date = ISO8601DateFormatter().date(from: info.date) else { return nil }
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        formatter.timeStyle = .none
                        return .init(title: title,
                                     date: formatter.string(from: date),
                                     url: info.url)
                    }
            }
            .receive(on: self.scheduler)
            .sink { [weak self] (entities: [InfomationViewCellEntity]) in
                self?.usecase.read()
                self?.cellEntities = entities
            }
            .store(in: &cancellables)
    }

    public func onAppear() {
        print("appear infomation view")
        fetch.send(())
    }

    public func onRefresh() {
        fetch.send(())
    }
}
