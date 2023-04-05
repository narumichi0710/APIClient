//
//  APIError.swift
//  
//
//  Created by Narumichi Kubo on 2023/04/04.
//

import Foundation

public enum APIError: Error, Equatable {
    case invalidURL
    case missingAccessToken
    case unavailableAuthSession
    case serverError
    case noResponse
    case other(String)

    var localize: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .missingAccessToken:
            return "アクセストークンがありません"
        case .unavailableAuthSession:
            return "認証に失敗しました"
        case .serverError:
            return "サーバーエラーが発生しました。"
        case .noResponse:
            return "サーバーからの応答がありません。少し時間を置いてからアクセスしてください。"
        default:
            return nil
        }
    }
}

extension APIError {
    public struct Message: Decodable, Equatable {
        public let documentationURL: URL
        public let errors: Errors
        public let message: String

        public struct Errors: Decodable, Equatable {
            public let resource: String
            public let field: String
            public let code: String

            private enum CodingKeys: String, CodingKey {
                case resource, field, code
            }
        }
        private enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case errors, message
        }
    }
}

