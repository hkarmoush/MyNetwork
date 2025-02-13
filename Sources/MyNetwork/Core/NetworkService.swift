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
    private let maxRetryCount: Int
    
    init(
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        responseParser: ResponseParserProtocol = ResponseParser(),
        session: URLSessionProtocol,
        interceptorManager: InterceptorManager = InterceptorManager(),
        maxRetryCount: Int = 3
    ) {
        self.requestBuilder = requestBuilder
        self.responseParser = responseParser
        self.session = session
        self.interceptorManager = interceptorManager
        self.maxRetryCount = maxRetryCount
    }
    
    func request<T: Decodable>(_ request: NetworkRequest) async -> Result<T, APIError> {
        guard var urlRequest = requestBuilder.buildRequest(from: request) else {
            return .failure(.unknown)
        }

        interceptorManager.applyInterceptors(to: &urlRequest)

        var attempts = 0
        while attempts <= maxRetryCount {
            do {
                let (data, response) = try await session.data(for: urlRequest)

                guard let httpResponse = response as? HTTPURLResponse else {
                    return .failure(.unknown)
                }

                guard !data.isEmpty else {
                    return .failure(.decodingError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response data"])))
                }

                interceptorManager.notifyInterceptors(data: data, response: response, error: nil)

                return responseParser.parseResponse(data, response: httpResponse)
            } catch {
                interceptorManager.notifyInterceptors(data: nil, response: nil, error: error)

                if attempts < maxRetryCount, shouldRetry(error) {
                    attempts += 1
                    print("🔄 Retrying request (\(attempts)/\(maxRetryCount))...")
                    continue
                }
                return .failure(.networkFailure(error))
            }
        }
        return .failure(.unknown)
    }
    
    private func shouldRetry(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain &&
        [NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost].contains(nsError.code)
    }
}
