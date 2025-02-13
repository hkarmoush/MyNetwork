//
//  RequestBuilder.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(from networkRequest: NetworkRequest) -> URLRequest?
}
