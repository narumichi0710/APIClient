//
//  APIManager.swift
//  
//
//  Created by Narumichi Kubo on 2023/05/25.
//

import SwiftUI

/// 通信状態管理用クラス
final public class APIStates: ObservableObject {
    public static var shared = APIStates()
    public var isRequestInProgress: Bool
    public var errorStatus: APIError?
    @Published private var modified: Date = .now
    
    public init(isRequestInProgress: Bool = false, errorStatus: APIError? = nil) {
        self.isRequestInProgress = isRequestInProgress
        self.errorStatus = errorStatus
    }
    
    public func start() {
        self.isRequestInProgress = true
    }
    
    public func finish(_ error: APIError? = nil) {
        isRequestInProgress = false
        errorStatus = error
    }
    
    public func update() {
        modified = .now
    }
}
