//
//  DessertDetailViewModel.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

@MainActor
final class DessertDetailViewModel: ObservableObject {
    @Published var detail: DessertDetail?
    @Published var errorString: String?
    @Published var isLoading = false
    
    let dessert: Dessert
    let networkManager: DessertNetworkManager
    
    init(dessert: Dessert, networkManager: DessertNetworkManager = .shared) {
        self.dessert = dessert
        self.networkManager = networkManager
        
        fetchDetails()
    }
    
    func fetchDetails() {
        isLoading = true
        
        Task {
            do {
                self.detail = try await self.networkManager.fetchDetails(for: dessert)
                isLoading = false
            } catch {
                if let ddError = error as? DDError {
                    errorString = ddError.description
                } else {
                    errorString = error.localizedDescription
                }
            }
        }
    }
}
