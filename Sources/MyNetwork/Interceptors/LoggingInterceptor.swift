//
//  LoggingInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Logs network requests, responses, and errors.
final class LoggingInterceptor: InterceptorProtocol {
    
    func interceptRequest(_ request: inout URLRequest) {
        debugPrint("📡 Sending Request: \(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            debugPrint("📡 Headers: \(headers)")
        }
    }
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        if let httpResponse = response as? HTTPURLResponse {
            debugPrint("📩 Response from \(httpResponse.url?.absoluteString ?? "") - Status Code: \(httpResponse.statusCode)")
        }
        if let error = error {
            debugPrint("❌ Request failed with error: \(error.localizedDescription)")
        }
    }
}
