//
//  InterceptorProtocol.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//

import Foundation

/// Protocol for interceptors to modify requests and responses.
protocol InterceptorProtocol {
    func interceptRequest(_ request: inout URLRequest)
    func interceptResponse(_ data: Data?, response: URLResponse?, error: Error?)
}
