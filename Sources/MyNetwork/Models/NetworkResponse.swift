//
//  NetworkResponse.swift
//  MyNetwork
//
//  Created by PersHasan on 13/02/2025.
//

struct NetworkResponse<T: Decodable> {
    let data: T
    let statusCode: Int
}
