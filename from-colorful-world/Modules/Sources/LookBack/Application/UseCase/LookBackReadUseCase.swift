//
//  LookBackReadUseCase.swift
//
//
//  Created by fuziki on 2022/05/04.
//

import Foundation

protocol LookBackReadUseCaseProtocol {
    func getAssignmentTitleList(calendar: Calendar, timeZone: TimeZone, date: Date) -> [String]
    func getDayResult(calendar: Calendar, timeZone: TimeZone, date: Date) -> [(title: String, ok: [Bool])]
}
