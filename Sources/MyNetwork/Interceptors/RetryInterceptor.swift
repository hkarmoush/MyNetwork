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
        // No modifications to request needed
    }
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        guard let error = error else { return }
        
        if let url = response?.url ?? URL(string: "https://test.com") {
            let currentAttempts = retryAttempts[url] ?? 0
            
            if currentAttempts < maxRetryCount {
                retryAttempts[url] = currentAttempts + 1
                print("🔄 Retrying request to \(url) (\(currentAttempts + 1)/\(maxRetryCount))")
                
                if #available(iOS 13.0, macOS 10.15, *) {
                    Task {
                        let request = URLRequest(url: url)
                        do {
                            let (_, _) = try await URLSession.shared.data(for: request)
                        } catch {
                            print("❌ Retry failed for \(url)")
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}
