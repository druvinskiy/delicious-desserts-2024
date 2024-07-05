//
//  DessertNetworkManager.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import Foundation

class DessertNetworkManager: ObservableObject {
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    static let shared = DessertNetworkManager()
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchDesserts() async throws -> [Dessert] {
        let endpoint = try Endpoint.meals(category: "Dessert").url
        let response: DessertResponse = try await fetch(url: endpoint)
        return response.meals
    }
    
    func fetchDetails(for dessert: Dessert) async throws -> DessertDetail {
        let endpoint = try Endpoint.details(id: dessert.id).url
        let response: DetailsResponse = try await fetch(url: endpoint)
        
        guard let details = response.detailsArray.first else {
            throw DDError.invalidData()
        }
        
        return details
    }
    
    /// Generic asynchronous method to retrieve data from a specified URL.
    ///
    /// - Parameter url: The URL from which to retrieve data.
    /// - Returns: A decoded object of type ``T`` that conforms to  ``Decodable``.
    private func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw DDError.invalidResponse()
        }
        
        guard response.statusCode == 200 else {
            let description = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            throw DDError.invalidResponse(description: description)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw DDError.invalidData(error: error)
        }
    }
}
