//
//  GitHubApi.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2020/08/30.
//

import Foundation

public protocol GitHubApi: HttpRequest {
    var path: String { get }
}

extension GitHubApi {
    public var baseUrl: String { "https://api.github.com/" }
    public var url: URL { URL(string: baseUrl + path)! }
}
