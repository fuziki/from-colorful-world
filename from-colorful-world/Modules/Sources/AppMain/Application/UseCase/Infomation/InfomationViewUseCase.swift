//
//  InfomationViewUseCase.swift
//
//
//  Created by fuziki on 2021/11/21.
//

import Core
import Combine
import Foundation

/// @mockable
protocol InfomationViewUseCase {
    func fetch(gistId: String) -> AnyPublisher<InformationApi.Response, Error>
    func read()
}

class DefaultInfomationViewUseCase: InfomationViewUseCase {
    public func fetch(gistId: String) -> AnyPublisher<InformationApi.Response, Error> {
        return GistGitHubApi(gistId: gistId)
            .request()
            .flatMap { (response: GistGitHubApi.Response) -> AnyPublisher<InformationApi.Response, Error> in
                guard let file = response.files["from-colorful-world-notice.json"],
                      let url = URL(string: file.rawUrl) else { return Empty().eraseToAnyPublisher() }
                return InformationApi(url: url)
                    .request()
            }
            .eraseToAnyPublisher()
    }

    public func read() {
        DefaultLatestReadInfomationUseCase().read(date: Date())
    }
}
