//
//  LoggingInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol LoggingInterceptorProtocol {
    func log(_ request: URLRequest, response: URLResponse?, data: Data?)
}
