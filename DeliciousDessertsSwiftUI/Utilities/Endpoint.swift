//
//  Endpoint.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import Foundation

enum Endpoint {
    case meals(category: String)
    case details(id: String)
    
    var url: URL {
        get throws {
            switch self {
            case .meals(let category):
                return try makeURL(for: "filter.php?c=\(category)")
            case .details(let id):
                return try makeURL(for: "lookup.php?i=\(id)")
            }
        }
    }
    
    private func makeURL(for endpoint: String) throws -> URL {
        let urlString = "https://www.themealdb.com/api/json/v1/1/\(endpoint)"
        
        guard let url = URL(string: urlString) else {
            throw DDError.invalidURL(urlString: urlString)
        }
        
        return url
    }
}
