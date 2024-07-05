//
//  DDError.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import Foundation

enum DDError: Error {
    case invalidURL(urlString: String)
    case invalidResponse(description: String? = nil)
    case invalidData(error: Error? = nil)
    
    var description: String {
        switch self {
        case .invalidURL(let urlString):
            return String(localized: "invalidURL \(urlString)")
        case .invalidResponse(let description):
            if let description = description {
                return description
            } else {
                return String(localized: "invalidResponse")
            }
        case .invalidData(let error):
            if let error = error {
                return error.localizedDescription
            } else {
                return String(localized: "invalidData")
            }
        }
    }
}
