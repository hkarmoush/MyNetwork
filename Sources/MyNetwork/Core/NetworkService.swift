//
//  NetworkService.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: NetworkRequest) async -> Result<T, APIError>
}
