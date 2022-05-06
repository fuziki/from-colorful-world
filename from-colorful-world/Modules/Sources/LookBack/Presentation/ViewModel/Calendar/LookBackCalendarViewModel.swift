//
//  LookBackCalendarViewModel.swift
//
//
//  Created by fuziki on 2022/05/06.
//

import Combine
import Foundation
import SwiftUI

class LookBackCalendarViewModel: ObservableObject {
    @Published public var date: Date
    @Published public var disableShowButton: Bool = true
    @Published public var isActiveNavigationLink: Bool = false
    @Published public var listTiles: [String] = []
    public let classPeaples: Int

    private let usecase: LookBackReadUseCaseProtocol

    private var cancellables: Set<AnyCancellable> = []
    init(date: Date, classPeaples: Int, usecase: LookBackReadUseCaseProtocol) {
        self.date = date
        self.classPeaples = classPeaples
        self.usecase = usecase

        $date.sink { [weak self] (date: Date) in
            let titles = self?.usecase.getAssignmentTitleList(calendar: .current, timeZone: .current, date: date) ?? []
            self?.listTiles = titles.isEmpty ? ["保存された結果がありません"] : titles
            self?.disableShowButton = titles.isEmpty
        }.store(in: &cancellables)
    }

    public func tapShowButton() {
        isActiveNavigationLink = true
    }

    public func onAppear() {
        date = date
    }
}
