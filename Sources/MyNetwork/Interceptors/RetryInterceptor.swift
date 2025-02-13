//
//  RetryInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol RetryInterceptorProtocol {
    func shouldRetry(_ response: URLResponse?, error: Error) -> Bool
}
