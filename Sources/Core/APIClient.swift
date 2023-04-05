//
//  APIClient.swift
//

import Foundation

// API通信用プロトコル
public protocol APIClient {
    var baseURL: URL { get }
    var headerFields: [String: String] { get }
    var session: URLSession { get }
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}

// 必要に応じて変更
extension APIClient {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    var headerFields: [String: String] {
        ["Accept": "application/json"]
    }
    var session: URLSession {
        .shared
    }
}

extension APIClient {
    /// リクエスト送信 / 受信処理
    public func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let urlRequest = try await request.urlRequest(baseURL: baseURL, headerFields: headerFields)
        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.other(httpResponse.description)
        }
        return try request.response(from: data)
    }
}
