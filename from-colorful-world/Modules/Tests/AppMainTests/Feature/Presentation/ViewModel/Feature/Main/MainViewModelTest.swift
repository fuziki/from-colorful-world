//
//  MainViewModelTest.swift
//
//
//  Created by fuziki on 2022/01/30.
//

import Combine
import CombineSchedulers
import Core
import XCTest
@testable import AppMain

final class MainViewModelTest: XCTestCase {
    func testNotRead() {
        var cancellables: Set<AnyCancellable> = []

        let latestInfomationDate = Date(timeIntervalSince1970: 1460214000)
        let usecase = MainViewUseCaseMock()
        usecase.fetchLatestInfomationDateHandler = { (_: String) -> AnyPublisher<Date, Error> in
            return .just(output: latestInfomationDate)
        }
        usecase.latestReadInfomationDate = nil
        let settingService = SettingServiceMock(currentEntity: .default)
        let viewModel = MainViewModel(usecase: usecase,
                                      settingService: settingService,
                                      inAppMessageService: InAppMessageServiceMock())

        let scheduler = DispatchQueue.test
        let showBadgeSubject = TestEventRecoder(outputType: Bool.self, testScheduler: scheduler)
        let now = scheduler.now

        scheduler.schedule(after: now.advanced(by: .seconds(1))) {
            viewModel.onAppear()
        }

        viewModel.showBadge.sink { (showBadge: Bool) in
            showBadgeSubject.send(showBadge)
        }.store(in: &cancellables)

        scheduler.advance(by: .seconds(3))

        XCTAssertEqual(showBadgeSubject.eventRecorded, lineAssertReferences: [
            .onNext(now, false),
            .onNext(now.advanced(by: .seconds(1)), true),
        ])
    }

    func testReadHasNew() {
        var cancellables: Set<AnyCancellable> = []

        let latestInfomationDate = Date(timeIntervalSince1970: 1460214000)
        let usecase = MainViewUseCaseMock()
        usecase.fetchLatestInfomationDateHandler = { (_: String) -> AnyPublisher<Date, Error> in
            return .just(output: latestInfomationDate)
        }
        usecase.latestReadInfomationDate = latestInfomationDate.advanced(by: -3600)
        let settingService = SettingServiceMock(currentEntity: .default)
        let viewModel = MainViewModel(usecase: usecase,
                                      settingService: settingService,
                                      inAppMessageService: InAppMessageServiceMock())

        let scheduler = DispatchQueue.test
        let showBadgeSubject = TestEventRecoder(outputType: Bool.self, testScheduler: scheduler)
        let now = scheduler.now

        scheduler.schedule(after: now.advanced(by: .seconds(1))) {
            viewModel.onAppear()
        }

        viewModel.showBadge.sink { (showBadge: Bool) in
            showBadgeSubject.send(showBadge)
        }.store(in: &cancellables)

        scheduler.advance(by: .seconds(3))

        XCTAssertEqual(showBadgeSubject.eventRecorded, lineAssertReferences: [
            .onNext(now, false),
            .onNext(now.advanced(by: .seconds(1)), true),
        ])
    }

    func testReadHasNoNew() {
        var cancellables: Set<AnyCancellable> = []

        let latestInfomationDate = Date(timeIntervalSince1970: 1460214000)
        let usecase = MainViewUseCaseMock()
        usecase.fetchLatestInfomationDateHandler = { (_: String) -> AnyPublisher<Date, Error> in
            return .just(output: latestInfomationDate)
        }
        usecase.latestReadInfomationDate = latestInfomationDate.advanced(by: 3600)
        let settingService = SettingServiceMock(currentEntity: .default)
        let viewModel = MainViewModel(usecase: usecase,
                                      settingService: settingService,
                                      inAppMessageService: InAppMessageServiceMock())

        let scheduler = DispatchQueue.test
        let showBadgeSubject = TestEventRecoder(outputType: Bool.self, testScheduler: scheduler)
        let now = scheduler.now

        scheduler.schedule(after: now.advanced(by: .seconds(1))) {
            viewModel.onAppear()
        }

        viewModel.showBadge.sink { (showBadge: Bool) in
            showBadgeSubject.send(showBadge)
        }.store(in: &cancellables)

        scheduler.advance(by: .seconds(3))

        XCTAssertEqual(showBadgeSubject.eventRecorded, lineAssertReferences: [
            .onNext(now, false),
            .onNext(now.advanced(by: .seconds(1)), false),
        ])
    }
}
