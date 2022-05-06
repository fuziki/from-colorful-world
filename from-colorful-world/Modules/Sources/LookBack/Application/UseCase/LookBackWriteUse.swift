//
//  LookBackWriteUse.swift
//
//
//  Created by fuziki on 2022/05/04.
//

import Foundation

public protocol LookBackWriteUseCaseProtocol {
    func detected(title: String, index: Int)
    func save(classPeaples: Int, calendar: Calendar, timeZone: TimeZone, date: Date)
}
