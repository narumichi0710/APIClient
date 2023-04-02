//
//  APIRequest.swift
//  

import Foundation

/// リクエスト用プロトコル
public protocol APIRequest {
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var path: String { get }
    var body: Encodable? { get }
    var queryParameters: [String: String]? { get }
}

extension APIRequest {
    
    public func urlRequest(
        baseURL: String,
        headerFields: [String: String]
    ) async throws -> URLRequest {
        
        var urlBuilder = URLBuilder(baseURL: baseURL)
        urlBuilder.appendPathComponent(path)
        urlBuilder.setQueryParameters(queryParameters)

        var request = URLRequest(url: try urlBuilder.url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = try await JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for (field, value) in headerFields {
            request.addValue(value, forHTTPHeaderField: field)
        }

        return request
    }

    public func response(from data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
