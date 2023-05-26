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
    
    // FIXME: もう少し良い書き方あるかも
    public func sendWithProgress() async -> Result<Response, APIError> {
        await MainActor.run {
            if !APIStates.shared.isRequestInProgress {
                APIStates.shared.update()
            }
        }
        let result = await send()
        await MainActor.run {
            APIStates.shared.update()
        }
        return result
    }
    
    public func send() async -> Result<Response, APIError> {
        do {
            APIStates.shared.start()
            
            let urlRequest = try await getUrlRequest()
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.noResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError("エラーコード: \(httpResponse.statusCode)")
            }
            
            let responseData = try decode(from: data)
            return handleResult(.success(responseData))
        } catch let error as APIError {
            return handleResult(.failure(error))
        } catch let error as DecodingError {
            return handleResult(.failure(.decodingError(error)))
        } catch let error {
            return handleResult(.failure(.otherError(error)))
        }
    }
    
    public func getUrlRequest() async throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidURL
        }
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let urlWithComponents = urlComponents.url else {
            throw APIError.invalidURL
        }
        var urlRequest = URLRequest(url: urlWithComponents)
        urlRequest.httpMethod = method.rawValue
        
        var bodyLog = String()
        if let body = body {
            let httpBody = try JSONEncoder().encode(body)
            urlRequest.httpBody = httpBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            bodyLog.append("\(String(data: httpBody, encoding: .utf8).toString)")
        }
        
        if !headerFields.isEmpty {
            for (field, value) in headerFields {
                urlRequest.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        debugPrint("API Request: \(urlRequest.httpMethod.toString) \(urlRequest.url.toString) \(urlRequest.allHTTPHeaderFields.toString) \((bodyLog))")
        return urlRequest
    }
    
    private func handleResult(_ result: Result<Response, APIError>) -> Result<Response, APIError> {
        debugPrint("Response: \(result)")
        switch result {
        case .success:
            APIStates.shared.finish()
            return result
        case .failure(let error):
            APIStates.shared.finish(error)
            return result
        }
    }
    
    public func decode(from data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}

public struct EmptyBody: Encodable {
    public init() {}
}

public struct EmptyResponse: Decodable {
    public init() {}
}

extension Optional {
    var toString: String {
        if let self {
            return "\(self)"
        }
        return ""
    }
}
