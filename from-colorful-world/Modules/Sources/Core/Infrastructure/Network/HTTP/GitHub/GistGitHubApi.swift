//
//  GistGitHubApi.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2020/08/30.
//

import Foundation

// https://api.github.com/gists/${{GIST_ID}}
public struct GistGitHubApi: GitHubApi {
    public struct Response: Codable {
        public struct File: Codable {
            public let rawUrl: String
            enum CodingKeys: String, CodingKey {
              case rawUrl = "raw_url"
            }
        }
        public let files: [String: File]
    }
    public let method: HttpRequestMethod = .get
    public var path: String { "gists/\(gistId)" }
    private var gistId: String
    public init(gistId: String) {
        self.gistId = gistId
    }
}
