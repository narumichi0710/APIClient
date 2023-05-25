//
//  SampleViewModel.swift
//  Demo
//
//  Created by Narumichi Kubo on 2023/04/05.
//

import SwiftUI

public class SampleViewModel: ObservableObject {
    private let apiClient: SampleClient
    
    @Published public var items = [SampleItem]()
    @Published public var searchText: String = ""
    
    public init(
        searchText: String = "",
        apiClient: SampleClient
    ) {
        self.apiClient = apiClient
    }
    
    func fetchUsers(isFail: Bool = false) async {
        // APIエラー確認のため、意図的にkeyを変更
        let keyValue = isFail ? ["hoge": "fuga"] : ["q": searchText]
        let result = await apiClient.user(.init(keyValue))
        await MainActor.run {
            switch result {
            case .success(let response):
                self.items = response.items
            case .failure(_):
                break
            }
        }
    }
}

