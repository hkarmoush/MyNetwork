//
//  ResponseParser.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Protocol to define a response parser
protocol ResponseParserProtocol {
    func parseResponse<T: Decodable>(_ data: Data, response: URLResponse) -> Result<T, APIError>
}

/// Concrete implementation of response parser
final class ResponseParser: ResponseParserProtocol {
    
    func parseResponse<T: Decodable>(_ data: Data, response: URLResponse) -> Result<T, APIError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unknown)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedObject)
            } catch {
                return .failure(.decodingError(error))
            }
        case 401:
            return .failure(.unauthorized)
        case 404:
            return .failure(.notFound)
        case 500...599:
            return .failure(.serverError)
        default:
            return .failure(.unknown)
        }
    }
}
