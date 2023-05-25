//
//  SampleView.swift
//  Demo
//
//  Created by Narumichi Kubo on 2023/04/02.
//

import SwiftUI
import APIClient

public struct SampleRootView: View {
    @StateObject var apiState: APIStates
    @StateObject private var viewModel: SampleViewModel
    
    public init(
        apiState: APIStates = .shared,
        viewModel: SampleViewModel = .init(apiClient: .live)
    ) {
        _apiState = .init(wrappedValue: apiState)
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VStack {
                SearchBar(text: $viewModel.searchText) {
                    Task {
                        await viewModel.fetchUsers()
                    }
                }
                SampleSubView(viewModel: viewModel)
            }
            
            DefaultProgressBar()
                .environmentObject(apiState)
            DefaultStatusCover()
                .environmentObject(apiState)
        }
    }

}

public struct SampleSubView: View {
    @ObservedObject private var viewModel: SampleViewModel
    
    public init(viewModel: SampleViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            } else {
                List(viewModel.items) { item in
                    Text(item.login)
                }
                .listStyle(.inset)
            }
            Spacer()
            HStack {
                Button("Check API") {
                    viewModel.errorMessage = nil
                    Task {
                        await viewModel.fetchUsers(isFail: false)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Fail API on purpose") {
                    Task {
                        await viewModel.fetchUsers(isFail: true)
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom, 16.0)
        }
    }
}


public struct SearchBar: View {
    @Binding private var text: String
    private var onSearchButtonClicked: () -> Void
    
    public init(
        text: Binding<String>,
        onSearchButtonClicked: @escaping () -> Void
    ) {
        _text = text
        self.onSearchButtonClicked = onSearchButtonClicked
    }
    
    public var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: {
                onSearchButtonClicked()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                onSearchButtonClicked()
            }) {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
    }
}
