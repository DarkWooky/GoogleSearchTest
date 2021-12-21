//
//  CustomError.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import Foundation

enum NetworkError: Error {
    case apiError
    case noConnection
    case invalidEndpoint
    case invalidDataOrResponse
    case serializationError

    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Stopped"
        case .noConnection:
            return "No internet connection"
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .invalidDataOrResponse:
            return "Invalid data or response"
        case .serializationError:
            return "Failed to decode data"
        }
    }
}
