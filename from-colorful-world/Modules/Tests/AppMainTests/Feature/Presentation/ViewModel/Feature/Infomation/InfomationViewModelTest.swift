//
//  InfomationViewModelTest.swift
//  
//
//  Created by fuziki on 2022/01/29.
//

import Combine
import Core
import XCTest
@testable import AppMain

final class InfomationViewModelTest: XCTestCase {
    func testAppear() {
        let date = Date(timeIntervalSince1970: 1460214000)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let usecase = InfomationViewUseCaseMock()
        usecase.fetchHandler = { (_: String) -> AnyPublisher<InformationApi.Response, Error> in
            let information: [InformationApi.Response.Information] = [
                .init(title: ["ja": "Pinch on the first voyage!"],
                      date: ISO8601DateFormatter().string(from: date),
                      url: URL(string: "http://example.com")!)
            ]
            return .just(output: .init(information: information))
        }

        let scheduler = RunLoop.test
        let viewModel = InfomationViewModel(usecase: usecase, scheduler: scheduler.eraseToAnyScheduler())

        XCTAssertEqual(viewModel.outputs.cellEntities, [])

        viewModel.inputs.onAppear()
        scheduler.advance(by: .zero)

        XCTAssertEqual(usecase.fetchCallCount, 1)
        XCTAssertEqual(usecase.readCallCount, 1)
        XCTAssertEqual(viewModel.outputs.cellEntities, [
            .init(title: "Pinch on the first voyage!", date: formatter.string(from: date), url: URL(string: "http://example.com")!)
        ])
    }

    func testErrorAndRefresh() {
        let date = Date(timeIntervalSince1970: 1460214000)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        let usecase = InfomationViewUseCaseMock()
        let scheduler = RunLoop.test
        let viewModel = InfomationViewModel(usecase: usecase, scheduler: scheduler.eraseToAnyScheduler())

        // test default
        XCTAssertEqual(viewModel.outputs.cellEntities, [])

        // test fetch error
        usecase.fetchHandler = { (_: String) -> AnyPublisher<InformationApi.Response, Error> in
            return .fail(error: NSError(domain: "test", code: 0) as Error)
        }
        viewModel.inputs.onAppear()
        scheduler.advance(by: .zero)
        XCTAssertEqual(usecase.fetchCallCount, 1)
        XCTAssertEqual(usecase.readCallCount, 0)
        XCTAssertEqual(viewModel.outputs.cellEntities, [])

        // test fetch success
        usecase.fetchHandler = { (_: String) -> AnyPublisher<InformationApi.Response, Error> in
            let information: [InformationApi.Response.Information] = [
                .init(title: ["ja": "Pinch on the first voyage!"],
                      date: ISO8601DateFormatter().string(from: date),
                      url: URL(string: "http://example.com")!)
            ]
            return .just(output: .init(information: information))
        }
        viewModel.inputs.onRefresh()
        scheduler.advance(by: .zero)
        XCTAssertEqual(usecase.fetchCallCount, 2)
        XCTAssertEqual(usecase.readCallCount, 1)
        XCTAssertEqual(viewModel.outputs.cellEntities, [
            .init(title: "Pinch on the first voyage!", date: formatter.string(from: date), url: URL(string: "http://example.com")!)
        ])
    }
}
