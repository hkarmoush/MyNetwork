//
//  APIError.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

enum APIError: Error {
    case networkFailure(Error)
    case decodingError(Error)
    case unauthorized
    case notFound
    case serverError
    case unknown
}
