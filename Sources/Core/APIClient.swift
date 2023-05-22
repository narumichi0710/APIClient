//
//  APIClient.swift
//

import Foundation

// API通信用プロトコル
public protocol APIClient {
    var baseURL: URL { get set }
    var headerFields: [String: String] { get set }
    var session: URLSession { get set }
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}

// 必要に応じて変更
extension APIClient {
    public var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    public var headerFields: [String: String] {
        ["Accept": "application/json"]
    }
    public var session: URLSession {
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
            let errorResponse = try? JSONDecoder().decode(APIError.Message.self, from: data)
            debugPrint("API Error: \(String(describing: errorResponse?.message)) ErrorCode: \(httpResponse.statusCode)")
            throw APIError.serverError
        }
        return try request.response(from: data)
    }
}
