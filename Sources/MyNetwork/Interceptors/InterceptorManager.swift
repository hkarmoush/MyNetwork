//
//  InterceptorManager.swift
//  MyNetwork
//
//  Created by PersHasan on 14/02/2025.
//


import Foundation

/// Manages multiple interceptors.
final class InterceptorManager {
    
    private var interceptors: [InterceptorProtocol] = []
    
    func addInterceptor(_ interceptor: InterceptorProtocol) {
        interceptors.append(interceptor)
    }
    
    func applyInterceptors(to request: inout URLRequest) {
        for interceptor in interceptors {
            interceptor.interceptRequest(&request)
        }
    }
    
    func notifyInterceptors(data: Data?, response: URLResponse?, error: Error?) {
        for interceptor in interceptors {
            interceptor.interceptResponse(data, response: response, error: error)
        }
    }
}