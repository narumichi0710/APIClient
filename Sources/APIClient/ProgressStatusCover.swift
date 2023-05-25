//
//  ProgressStatusCover.swift
//  
//
//  Created by Narumichi Kubo on 2023/05/26.
//

import SwiftUI

public struct DefaultProgressBar: View {
    @EnvironmentObject var apiState: APIStates
    
    public init() {}
    
    public var body: some View {
        if apiState.isRequestInProgress {
            ZStack {
                Color.gray
                    .opacity(0.15)
                ProgressView()
            }
            .ignoresSafeArea()
        }
    }
}

public struct DefaultStatusCover: View {
    @EnvironmentObject var apiState: APIStates

    public init() {}
    
    public var body: some View {
        Color.clear
            .alert(
                "エラー",
                isPresented: .init(
                    get: { apiState.errorStatus != nil },
                    set: { apiState.errorStatus = $0 ? nil : apiState.errorStatus }
                ),
                actions: {
                    Button("閉じる") {
                        apiState.errorStatus = nil
                    }
                },
                message: {
                    Text(apiState.errorStatus?.localize ?? "")
                }
            )
    }
}
