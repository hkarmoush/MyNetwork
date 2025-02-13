//
//  RequestBuilder.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Protocol to define a request builder
protocol RequestBuilderProtocol {
    func buildRequest(from networkRequest: NetworkRequest) -> URLRequest?
}

/// Concrete implementation of request builder
final class RequestBuilder: RequestBuilderProtocol {
    
    func buildRequest(from networkRequest: NetworkRequest) -> URLRequest? {
        guard let url = URL(string: networkRequest.endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = networkRequest.method.rawValue
        
        if let headers = networkRequest.headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if let body = networkRequest.body {
            request.httpBody = try? JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
