//
//  InterceptorTests.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//

import XCTest
@testable import MyNetwork

@available(iOS 13.0, macOS 10.15, *)
final class InterceptorTests: XCTestCase {
    
    // Mock Dependencies
    var mockURLSession: MockURLSession!
    var mockRequestBuilder: MockRequestBuilder!
    var mockResponseParser: MockResponseParser!
    var interceptorManager: InterceptorManager!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        mockRequestBuilder = MockRequestBuilder()
        mockResponseParser = MockResponseParser()
        interceptorManager = InterceptorManager()
    }
    
    override func tearDown() {
        mockURLSession = nil
        mockRequestBuilder = nil
        mockResponseParser = nil
        interceptorManager = nil
        
        super.tearDown()
    }
    
    func testAuthInterceptorAddsAuthorizationHeader() {
        // Given
        let expectedToken = "test-api-token"
        let authInterceptor = AuthInterceptor { expectedToken }
        var request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        authInterceptor.interceptRequest(&request)
        
        // Then
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expectedToken)")
    }
    
    func testRetryInterceptorRetriesRequestOnFailure() async {
        // Given
        mockURLSession.mockError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil)
        
        let request = NetworkRequest(endpoint: "https://test.com", method: .get)
        
        let networkService = NetworkService(
            requestBuilder: mockRequestBuilder,
            responseParser: mockResponseParser,
            session: mockURLSession,
            interceptorManager: interceptorManager,
            maxRetryCount: 3 // Ensure we test exactly 3 retries
        )
        
        // When
        let _: Result<User, APIError> = await networkService.request(request)
        
        // Then
        XCTAssertEqual(mockURLSession.requestCount, 4, "Expected 4 requests (1 initial + 3 retries), but got \(mockURLSession.requestCount)")
    }
    
    func testLoggingInterceptorLogsRequestAndResponse() {
        // Given
        var loggedMessages: [String] = []
        let loggingInterceptor = LoggingInterceptor { message in
            loggedMessages.append(message)
        }
        
        var request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        loggingInterceptor.interceptRequest(&request)
        loggingInterceptor.interceptResponse(Data(), response: HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                                               statusCode: 200,
                                                                               httpVersion: nil,
                                                                               headerFields: nil),
                                             error: nil)
        
        // Then
        XCTAssertTrue(loggedMessages.contains(where: { $0.contains("📡 Sending Request") }),
                      "Expected log message for request was not found")
        XCTAssertTrue(loggedMessages.contains(where: { $0.contains("📩 Response from") }),
                      "Expected log message for response was not found")
    }
    
    func testAuthInterceptorDoesNotAddAuthorizationHeaderWhenTokenIsNil() {
        // Given
        let authInterceptor = AuthInterceptor { nil }
        var request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        authInterceptor.interceptRequest(&request)
        
        // Then
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"), "Authorization header should not be added when token is nil")
    }
}
