//
//  DessertsViewModel.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

@MainActor
final class DessertsViewModel: ObservableObject {
    @Published var desserts = [Dessert]()
    @Published var isLoading = false
    @Published var errorString: String?
    
    let networkManager: DessertNetworkManager
    
    init(networkManager: DessertNetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchDesserts() {
        isLoading = true
        
        Task {
            do {
                self.desserts = try await networkManager.fetchDesserts()
                    .sorted()
                
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
