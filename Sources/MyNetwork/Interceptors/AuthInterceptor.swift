//
//  AuthInterceptor.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

import Foundation

protocol AuthInterceptorProtocol {
    func modifyRequest(_ request: inout URLRequest)
}
