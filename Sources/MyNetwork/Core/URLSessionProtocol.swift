//
//  URLSessionProtocol.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

@available(iOS 13.0, macOS 10.15, *)
extension URLSession: URLSessionProtocol {}
