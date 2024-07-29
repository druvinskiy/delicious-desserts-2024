//
//  DessertDetailView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

struct DessertDetailView: View {
    enum LoadingState {
        case loading
        case data(DessertDetailViewModel)
        case error(Error)
    }
    
    @State private var loadingState: LoadingState = .loading
    @EnvironmentObject var networkManager: DessertNetworkManager
    
    var dessert: Dessert
    
    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                LoadingView()
            case .data(let viewModel):
                Form {
                    Section(String(localized: "header-view.ingredients-section.name")) {
                        List {
                            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }
                        }
                    }
                    
                    Section(String(localized: "header-view.instructions-section.name")) {
                        List {
                            Text(viewModel.instructions)
                        }
                    }
                }
            case .error(let error):
                ErrorView(message: error.localizedDescription)
            }
        }
        .task {
            fetchDetails()
        }
        .navigationTitle(dessert.name)
    }
    
    func fetchDetails() {
        Task {
            do {
                let detail = try await networkManager.fetchDetails(for: dessert)
                let viewModel = DessertDetailViewModel(detail: detail)
                
                loadingState = .data(viewModel)
            } catch {
                loadingState = .error(error)
            }
        }
    }
}
