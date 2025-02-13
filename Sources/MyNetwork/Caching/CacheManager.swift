//
//  CacheManager.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol CacheManagerProtocol {
    func saveResponse(_ data: Data, for request: URLRequest)
    func retrieveResponse(for request: URLRequest) -> Data?
}
