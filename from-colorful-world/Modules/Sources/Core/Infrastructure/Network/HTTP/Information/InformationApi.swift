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
            public init(title: [String: String], date: String, url: URL) {
                self.title = title
                self.date = date
                self.url = url
            }
        }
        public let information: [Information]
        public init(information: [InformationApi.Response.Information]) {
            self.information = information
        }
    }
    public let method: HttpRequestMethod = .get
    public init(url: URL) {
        self.url = url
    }
}
