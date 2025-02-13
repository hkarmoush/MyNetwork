//
//  RetryInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Retries failed requests for transient errors.
final class RetryInterceptor: InterceptorProtocol {
    
    private let maxRetryCount: Int
    private var retryAttempts: [URL: Int] = [:]
    
    init(maxRetryCount: Int = 3) {
        self.maxRetryCount = maxRetryCount
    }
    
    func interceptRequest(_ request: inout URLRequest) {}
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("❌ Request failed, no retrying in interceptor: \(error.localizedDescription)")
        }
    }
}
