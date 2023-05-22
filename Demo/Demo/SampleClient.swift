//
//  SampleClient.swift
//  Demo
//
//  Created by Narumichi Kubo on 2023/04/05.
//

import Foundation
import APIClient

public struct SampleClient {
    public var user: (SampleRequest) async -> Result<SampleModel, APIError>
}

public extension SampleClient {
    static var live = SampleClient { request in
        await request.send()
    }
}

public struct SampleRequest: CommonRequest {
    public typealias Response = SampleModel
    public var method: HTTPMethod { .get }
    public var path: String { "/search/users" }
    public var queryParameters: [String: String]?

    public init(query: String) {
        self.queryParameters = ["q": query]
    }
}

public protocol CommonRequest: APIRequest {}

extension CommonRequest {
    public var baseURL: URL { .init(string: "https://api.github.com")! }
}
