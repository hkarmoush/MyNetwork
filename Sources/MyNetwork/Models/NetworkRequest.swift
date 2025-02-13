//
//  NetworkRequest.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

struct NetworkRequest {
    let endpoint: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Encodable?
}
