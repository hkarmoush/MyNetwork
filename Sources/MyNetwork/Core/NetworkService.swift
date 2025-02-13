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
    private let interceptorManager: InterceptorManager
    
    init(
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        responseParser: ResponseParserProtocol = ResponseParser(),
        session: URLSessionProtocol,
        interceptorManager: InterceptorManager = InterceptorManager()
    ) {
        self.requestBuilder = requestBuilder
        self.responseParser = responseParser
        self.session = session
        self.interceptorManager = interceptorManager
    }
    
    func request<T: Decodable>(_ request: NetworkRequest) async -> Result<T, APIError> {
        guard var urlRequest = requestBuilder.buildRequest(from: request) else {
            return .failure(.unknown)
        }
        
        interceptorManager.applyInterceptors(to: &urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            interceptorManager.notifyInterceptors(data: data, response: response, error: nil)
            
            return responseParser.parseResponse(data, response: response)
        } catch {
            interceptorManager.notifyInterceptors(data: nil, response: nil, error: error)
            return .failure(.networkFailure(error))
        }
    }
}
