//
//  HttpRequest.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2020/08/27.
//

import Combine
import Foundation

public protocol HttpClient {
    func request(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

class HttpClientProvider {
    static let shared = HttpClientProvider()
    dynamic var `default`: HttpClient {
        return UrlSessionClient()
    }
}

class UrlSessionClient: HttpClient {
    func request(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}

public enum HttpRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol HttpRequest {
    associatedtype Response
    var method: HttpRequestMethod { get }
    var url: URL { get }
    var client: HttpClient { get }
    func request() -> AnyPublisher<Response, Error>
}

extension HttpRequest {
    public var client: HttpClient {
        return HttpClientProvider.shared.default
    }
    private func requestData() -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return client
            .request(request: request)
            .tryMap { (output: URLSession.DataTaskPublisher.Output) -> Data in
                guard let res = output.response as? HTTPURLResponse, 200 ..< 300 ~= res.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .handleEvents(receiveSubscription: { (_: Subscription) in
            }, receiveOutput: { (_: Data) in
            }, receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                if case .failure(let failure) = completion {
                    print("error: \(failure)")
                }
            }, receiveCancel: {
            }, receiveRequest: { (_: Subscribers.Demand) in
            })
            .eraseToAnyPublisher()
    }

    // Codable Response
    public func request() -> AnyPublisher<Response, Error> where Response: Codable {
        return requestData()
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
