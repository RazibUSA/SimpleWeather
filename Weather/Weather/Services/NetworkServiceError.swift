//
//  NetworkServiceError.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import Foundation
// MARK: - Network Error Types

enum NetworkServiceError: LocalizedError, Equatable {
    case badRequest
    case decodingError(_ description: String)
    case forbidden
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case invalidRequest
    case notFound
    case unauthorized
    case urlSessionFailed(_ error: URLError)
    case unknownError
    case serverError
}
