//
//  APIRequest.swift
//  

import Foundation

/// リクエスト送信用プロトコル
public protocol APIRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var session: URLSession { get }
    var headerFields: [String: String] { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var body: Encodable? { get }
    var queryParameters: [String: String]? { get }
    var authorization: String { get }
}

extension APIRequest {
    public var baseURL: URL { .init(string: "")! }
    public var session: URLSession { .shared }
    public var headerFields: [String: String] { ["Accept": "application/json"] }
    public var body: Encodable? { nil }
    public var queryParameters: [String: String]? { nil }
    public var path: String { "" }
    public var authorization: String { "" }
}

extension APIRequest {
        
    public func send() async -> Result<Response, APIError> {
        do {
            let urlRequest = try await getUrlRequest()
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.noResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError("エラーコード: \(httpResponse.statusCode)")
            }
            let responseData = try decode(from: data)
            return .success(responseData)
        } catch let error as APIError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch let error {
            return .failure(.otherError(error))
        }
    }
    
    public func getUrlRequest() async throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidURL
        }
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let urlWithComponents = urlComponents.url else {
            throw APIError.invalidURL
        }
        var urlRequest = URLRequest(url: urlWithComponents)
        urlRequest.httpMethod = method.rawValue
        
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        for (field, value) in headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }

        debugPrint("API Request: \(urlRequest.httpMethod!) \(urlRequest.url!) \(urlRequest.allHTTPHeaderFields!)")
        return urlRequest
    }
    
    public func decode(from data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
