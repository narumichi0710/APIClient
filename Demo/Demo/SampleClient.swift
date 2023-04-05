//
//  SampleClient.swift
//  Demo
//
//  Created by Narumichi Kubo on 2023/04/05.
//

import Foundation
import Core

public class SampleClient: APIClient {
    public init() {}

    public func send(request: SampleRequest) async throws -> SampleModel {
        try await self.send(request)
    }
}

public struct SampleRequest: APIRequest {
    public typealias Response = SampleModel
    public var method: HTTPMethod { .get }
    public var path: String { "/search/users" }
    public var queryParameters: [String: String]?

    public init(query: String) {
        self.queryParameters = ["q": query]
    }
}
