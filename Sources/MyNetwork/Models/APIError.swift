//
//  APIError.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

enum APIError: Error, Equatable {
    case networkFailure(Error)
    case decodingError(Error)
    case unauthorized
    case notFound
    case serverError
    case unknown
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.networkFailure, .networkFailure),
            (.decodingError, .decodingError),
            (.unauthorized, .unauthorized),
            (.notFound, .notFound),
            (.serverError, .serverError),
            (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
