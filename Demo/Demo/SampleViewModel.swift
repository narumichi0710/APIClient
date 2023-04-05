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
    
    public init(apiClient: SampleClient) {
        self.apiClient = apiClient
    }
    
    public func fetchUsers() async {
        do {
            let request = SampleRequest(query: searchText)
            let response = try await apiClient.send(request)
            self.items = response.items
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}




