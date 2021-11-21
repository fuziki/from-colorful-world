//
//  MainViewUseCase.swift
//
//
//  Created by fuziki on 2021/11/21.
//

import Combine
import Core
import Foundation

protocol MainViewUseCase {
    var latestReadInfomationDate: Date? { get }
    func fetchLatestInfomationDate(gistId: String) -> AnyPublisher<Date, Error>
}

class DefaultMainViewUseCase: MainViewUseCase {
    public var latestReadInfomationDate: Date? {
        return DefaultLatestReadInfomationUseCase().latestDate
    }

    public func fetchLatestInfomationDate(gistId: String) -> AnyPublisher<Date, Error> {
        return GistGitHubApi(gistId: gistId)
            .request()
            .flatMap { (response: GistGitHubApi.Response) -> AnyPublisher<InformationApi.Response, Error> in
                guard let file = response.files["from-colorful-world-notice.json"],
                      let url = URL(string: file.rawUrl) else { return Empty().eraseToAnyPublisher() }
                return InformationApi(url: url)
                    .request()
            }
            .map { (response: InformationApi.Response) -> Date? in
                let dateList = response.information
                    .compactMap { ISO8601DateFormatter().date(from: $0.date) }
                    .sorted { $0 > $1 }
                return dateList.first
            }
            .filterNil()
    }
}
