//
//  InformationPbApi.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2021/01/24.
//

import Foundation

public struct InformationApi: HttpRequest {
    public let url: URL
    public struct Response: Codable {
        public struct Information: Codable {
            public let title: [String: String]
            public let date: String
            public let url: URL
        }
        public let information: [Information]
    }
    public let method: HttpRequestMethod = .get
    public init(url: URL) {
        self.url = url
    }
}
