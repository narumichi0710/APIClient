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
    case decodingError(DecodingError)
    case otherError(Error)

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
        case .serverError(let text):
            return "サーバーエラーが発生しました。\n\(text)"
        case .decodingError(let error):
            // TODO: ターゲットによって開発者確認用エラー内容の表示を切り替える
            let text: String
            switch error {
            case .dataCorrupted(let context):
                text = "データが破損しています。\(context.debugDescription)"
            case .keyNotFound(let key, let context):
                text = "'\(key)'が見つかりません。\(context.debugDescription)"
            case .typeMismatch(let type, let context):
                text = "'\(type)' が一致しません。\(context.debugDescription)"
            case .valueNotFound(let type, let context):
                text = "'\(type)' が見つかりません。\(context.debugDescription)"
            @unknown default:
                text = ""
            }
            return "データの変換に失敗しました。\n開発者確認用エラー内容:\n\(text)"
        case .otherError(let error):
            return "予期せぬエラーが発生しました。\n\(error.localizedDescription)"
        }
    }
}
