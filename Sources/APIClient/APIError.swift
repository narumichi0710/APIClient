//
//  APIError.swift
//  
//
//  Created by Narumichi Kubo on 2023/04/04.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case missingAccessToken
    case unavailableAuthSession
    case noResponse
    case serverError(String)
    case decodingError(String)

    public var localize: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .missingAccessToken:
            return "アクセストークンがありません"
        case .unavailableAuthSession:
            return "認証に失敗しました"
        case .noResponse:
            return "サーバーからの応答がありません。少し時間を置いてからアクセスしてください。"
        case .serverError(let error):
            return "サーバーエラーが発生しました。\n\(error)"
        case .decodingError(let error):
            return "予期せぬエラーが発生しました。\n\(error)"
        }
    }
}
