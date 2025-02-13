//
//  LoggingInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Logs network requests, responses, and errors.
final class LoggingInterceptor: InterceptorProtocol {
    
    private let logger: (String) -> Void
    
    init(logger: @escaping (String) -> Void = { print($0) }) {
        self.logger = logger
    }
    
    func interceptRequest(_ request: inout URLRequest) {
        logger("📡 Sending Request: \(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            logger("📡 Headers: \(headers)")
        }
    }
    
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        if let httpResponse = response as? HTTPURLResponse {
            logger("📩 Response from \(httpResponse.url?.absoluteString ?? "") - Status Code: \(httpResponse.statusCode)")
        }
        if let error = error {
            logger("❌ Request failed with error: \(error.localizedDescription)")
        }
    }
}
