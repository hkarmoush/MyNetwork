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
    
    func interceptRequest(_ request: inout URLRequest) {
        // No changes to request
    }
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        guard let url = response?.url, let error = error else { return }
        
        // Track retry attempts
        let currentAttempts = retryAttempts[url] ?? 0
        if currentAttempts < maxRetryCount {
            retryAttempts[url] = currentAttempts + 1
            print("🔄 Retrying request to \(url) (\(currentAttempts + 1)/\(maxRetryCount))")
            
            // Re-attempt request (this requires modifying `NetworkService`)
        }
    }
}
