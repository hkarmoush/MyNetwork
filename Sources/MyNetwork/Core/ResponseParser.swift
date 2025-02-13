//
//  ResponseParser.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol ResponseParserProtocol {
    func parseResponse<T: Decodable>(_ data: Data, response: URLResponse) -> Result<T, APIError>
}
