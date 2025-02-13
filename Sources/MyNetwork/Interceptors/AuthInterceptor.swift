//
//  AuthInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Handles authentication by injecting tokens into requests.
final class AuthInterceptor: InterceptorProtocol {
    
    private let tokenProvider: () -> String?
    
    init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }
    
    func interceptRequest(_ request: inout URLRequest) {
        guard let token = tokenProvider() else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        // No action needed for response interception
    }
}

// let authInterceptor = AuthInterceptor { "your-api-token" }
