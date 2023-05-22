//
//  SampleModel.swift
//  Demo
//
//  Created by Narumichi Kubo on 2023/04/05.
//

import Foundation
import APIClient

public struct SampleModel: Decodable, Equatable {
    public var totalCount: Int
    public var incompleteResults: Bool
    public var items: [SampleItem]
    
    public init(
        totalCount: Int,
        incompleteResults: Bool,
        items: [SampleItem]
    ) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
    
    public static let mockUsers = SampleModel(
        totalCount: 2,
        incompleteResults: false,
        items: [
            SampleItem(
                login: "narumichi0710",
                avatarUrl: "https://avatars.githubusercontent.com/u/65114797?v=4",
                reposUrl: "https://api.github.com/users/narumichi0710/repos"
            ),
            SampleItem(
                login: "narumichi0710",
                avatarUrl: "https://avatars.githubusercontent.com/u/65114797?v=4",
                reposUrl: "https://api.github.com/users/narumichi0710/repos"
            )
        ]
    )
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

public struct SampleItem: Decodable, Equatable, Identifiable {
    public var id = UUID()
    public var login: String
    public var avatarUrl: String
    public var reposUrl: String
    
    public init(
        id: UUID = UUID(),
        login: String,
        avatarUrl: String,
        reposUrl: String
    ) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.reposUrl = reposUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}
