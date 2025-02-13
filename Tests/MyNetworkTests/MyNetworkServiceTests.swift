//
//  MyNetworkServiceTests.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//

import XCTest
@testable import MyNetwork

@available(iOS 13.0, macOS 10.15, *)
final class NetworkServiceTests: XCTestCase {
    
    var mockRequestBuilder: MockRequestBuilder!
    var mockResponseParser: MockResponseParser!
    var mockURLSession: MockURLSession!
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        
        mockRequestBuilder = MockRequestBuilder()
        mockResponseParser = MockResponseParser()
        mockURLSession = MockURLSession()
        
        networkService = NetworkService(
            requestBuilder: mockRequestBuilder,
            responseParser: mockResponseParser,
            session: mockURLSession
        )
    }
    
    override func tearDown() {
        mockRequestBuilder = nil
        mockResponseParser = nil
        mockURLSession = nil
        networkService = nil
        
        super.tearDown()
    }
    
    func testSuccessfulResponse() async {
        // Given
        let expectedUser = User(id: 1, name: "John Doe", email: "john@example.com")
        let jsonData = try! JSONEncoder().encode(expectedUser)
        
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil)
        mockResponseParser.mockResult = .success(expectedUser)
        
        let request = NetworkRequest(endpoint: "https://test.com", method: .get)
        
        // When
        let result: Result<User, APIError> = await networkService.request(request)
        
        // Then
        switch result {
        case .success(let user):
            XCTAssertEqual(user.id, expectedUser.id)
            XCTAssertEqual(user.name, expectedUser.name)
            XCTAssertEqual(user.email, expectedUser.email)
        case .failure:
            XCTFail("Expected success but received failure")
        }
    }
    
    func testNetworkFailure() async {
        // Given
        let expectedError = NSError(domain: "network", code: -1009, userInfo: nil)
        mockURLSession.mockError = expectedError
        
        let request = NetworkRequest(endpoint: "https://test.com", method: .get)
        
        // When
        let result: Result<User, APIError> = await networkService.request(request)
        
        // Then
        if case .failure(let error) = result {
            if case .networkFailure(let receivedError) = error {
                XCTAssertEqual((receivedError as NSError).code, expectedError.code)
            } else {
                XCTFail("Expected network failure but received different error")
            }
        } else {
            XCTFail("Expected failure but received success")
        }
    }
    
    func testInvalidJSONResponse() async {
        // Given
        let invalidJsonData = Data("invalid json".utf8)
        mockURLSession.mockData = invalidJsonData
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                      statusCode: 200,
                                                      httpVersion: nil,
                                                      headerFields: nil)
        mockResponseParser.mockResult = .failure(.decodingError(NSError(domain: "", code: -1, userInfo: nil)))
        
        let request = NetworkRequest(endpoint: "https://test.com", method: .get)
        
        // When
        let result: Result<User, APIError> = await networkService.request(request)
        
        // Then
        if case .failure(let error) = result {
            if case .decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected decoding error but received different error")
            }
        } else {
            XCTFail("Expected failure but received success")
        }
    }
}

final class MockRequestBuilder: RequestBuilderProtocol {
    func buildRequest(from networkRequest: NetworkRequest) -> URLRequest? {
        return URLRequest(url: URL(string: networkRequest.endpoint)!)
    }
}

final class MockResponseParser: ResponseParserProtocol {
    var mockResult: Result<User, APIError>?
    
    func parseResponse<T: Decodable>(_ data: Data, response: URLResponse) -> Result<T, APIError> {
        return mockResult as! Result<T, APIError>
    }
}

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let email: String
}
