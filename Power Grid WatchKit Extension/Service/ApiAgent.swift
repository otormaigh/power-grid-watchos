//
//  ApiAgent.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 14/11/2021.
//

import Foundation
import Combine

struct ApiAgent {
    struct Response<T> {
        let value: T
        let response: HTTPURLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response as! HTTPURLResponse)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

func extractBaseUrl(url: String) -> String {
    if let urlComponents = URLComponents(string: url), let host = urlComponents.host {
        guard host.hasPrefix("www.") else { return host }
        return String(host.dropFirst(4))
    }
    return url
}

enum ApiError: Error {
    case http
}
