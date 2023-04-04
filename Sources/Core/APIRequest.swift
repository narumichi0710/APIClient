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
    
    public func urlRequest(baseURL: URL, headerFields: [String: String]) async throws -> URLRequest {
       let url = baseURL.appendingPathComponent(path)
       guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
           throw APIError.serverError
       }
       if let queryParameters = queryParameters {
           urlComponents.queryItems = queryParameters.map {
               URLQueryItem(name: $0.key, value: $0.value)
           }
       }
       guard let urlWithComponents = urlComponents.url else {
           throw APIError.serverError
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
       return urlRequest
   }
    
    
    public func response(from data: Data) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
