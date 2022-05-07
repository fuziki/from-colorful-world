//
//  DayResultViewModel.swift
//
//
//  Created by fuziki on 2022/05/06.
//

import Combine
import Foundation
import SwiftUI

struct LookBackAssignmentViewGridCellEntity: Hashable {
    let id: String
    let text: String
    let foregroundColor: Color
    let backgroundColor: Color
}

class DayResultViewModel: ObservableObject {
    // MARK: - Outputs
    @Published var title: String = ""
    @Published var titleColumns: [[LookBackAssignmentViewGridCellEntity]]
    @Published var resultColumns: [[LookBackAssignmentViewGridCellEntity]] = []
    @Published var isEmpty: Bool = false

    // MARK: - Injected
    private let calendar: Calendar
    private let usecase: LookBackReadUseCaseProtocol
    private let classPeaples: Int

    // MARK: - Properties
    private let date: CurrentValueSubject<Date, Never>
    private let rowCount: Int

    private var cancellables: Set<AnyCancellable> = []
    init(date: Date, calendar: Calendar, classPeaples: Int, usecase: LookBackReadUseCaseProtocol) {
        self.date =  CurrentValueSubject<Date, Never>(date)
        self.calendar = calendar
        self.usecase = usecase
        self.classPeaples = classPeaples
        self.rowCount = classPeaples + 1

        titleColumns = [
            // 固有idであれば良いのでランダムな文字列
            (0..<rowCount).map { .init(id: "s-64afcc4c-\($0)",
                                       text: $0 == 0 ? "出席番号" : "\($0)",
                                       foregroundColor: .primary,
                                       backgroundColor: Self.bc(i: $0)) }
        ]
        setupDate()
    }

    private static func bc(i: Int) -> Color {
        return (i % 2) == 0 ? .secondarySystemGroupedBackground : .systemGroupedBackground.opacity(0.4)
    }

    private func setupDate() {
        date.sink { [weak self] (date: Date) in
            self?.update(date: date)
        }.store(in: &cancellables)
    }
    private func update(date: Date) {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdE")
        self.title = formatter.string(from: date)

        let res = usecase.getDayResult(calendar: calendar, timeZone: .current, date: date)
        isEmpty = res.isEmpty
        resultColumns = res.map { (title: String, ok: [Bool]) -> [LookBackAssignmentViewGridCellEntity] in
            return (0..<rowCount).map { (i: Int) in
                let k = ok[safe: i - 1] ?? false
                let text: String
                switch i {
                case let i where i == 0:
                    text = title
                case let i where i <= ok.count:
                    text = k ? "OK!" : "\(i)"
                default:
                    text = ""
                }
                return .init(id: "\(title)-\(i)",
                             text: text,
                             foregroundColor: k ? .blue : .primary,
                             backgroundColor: Self.bc(i: i))
            }
        }
    }

    // MARK: - Inputs
    public func prevDate() {
        let value = date.value
        guard let added = calendar.date(byAdding: .day, value: -1, to: value) else { return }
        date.send(added)
    }

    public func nextDate() {
        let value = date.value
        guard let added = calendar.date(byAdding: .day, value: 1, to: value) else { return }
        date.send(added)
    }
}
