//
//  MockURLSession.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//

import Foundation
@testable import MyNetwork

@available(iOS 13.0, macOS 10.15, *)
final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var requestCount = 0
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requestCount += 1
        
        // Simulate transient failure for the first few attempts
        if requestCount <= 3, let error = mockError {
            throw error
        }
        
        // Ensure a valid response is available
        guard let response = mockResponse else {
            throw NSError(domain: "MockSession", code: 0, userInfo: nil)
        }
        
        return (mockData ?? Data(), response)
    }
}
