//
//  NetworkRequest.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

/// Represents a network request
struct NetworkRequest {
    let endpoint: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Encodable?
    
    init(endpoint: String, method: HTTPMethod = .get, headers: [String: String]? = nil, body: Encodable? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.body = body
    }
}
