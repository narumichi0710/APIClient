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
    @Published public var errorMessage: String?
    
    public init(
        searchText: String = "",
        apiClient: SampleClient
    ) {
        self.apiClient = apiClient
    }
    
    func fetchUsers() async {
        let result = await apiClient.user(.init(query: searchText))
        Task { @MainActor in
            switch result {
            case .success(let response):
                self.items = response.items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

