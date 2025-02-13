//
//  NetworkService.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

/// Protocol to allow dependency injection
protocol NetworkServiceProtocol {
    @available(iOS 13.0, macOS 10.15, *)
    func request<T: Decodable>(_ request: NetworkRequest) async -> Result<T, APIError>
}

/// Concrete implementation of the networking service
@available(iOS 13.0, macOS 10.15, *)
final class NetworkService: NetworkServiceProtocol {
    
    private let requestBuilder: RequestBuilderProtocol
    private let responseParser: ResponseParserProtocol
    private let session: URLSessionProtocol
    
    init(
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        responseParser: ResponseParserProtocol = ResponseParser(),
        session: URLSessionProtocol
    ) {
        self.requestBuilder = requestBuilder
        self.responseParser = responseParser
        self.session = session
    }
    
    func request<T: Decodable>(_ request: NetworkRequest) async -> Result<T, APIError> {
        guard let urlRequest = requestBuilder.buildRequest(from: request) else {
            return .failure(.unknown)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            return responseParser.parseResponse(data, response: response)
        } catch {
            return .failure(.networkFailure(error))
        }
    }
}
