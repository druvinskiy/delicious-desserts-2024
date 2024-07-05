//
//  DessertDetailView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

struct DessertDetailView: View {
    @StateObject var viewModel: DessertDetailViewModel
    
    var body: some View {
        if let errorString = viewModel.errorString {
            ErrorView(message: errorString)
        } else if viewModel.isLoading {
            LoadingView()
        } else {
            Form {
                Section(String(localized: "header-view.ingredients-section.name")) {
                    List {
                        ForEach(viewModel.detail?.ingredients ?? []) { ingredient in
                            Text("\(ingredient.measurement) \(ingredient.name)")
                        }
                    }
                }
                
                Section(String(localized: "header-view.instructions-section.name")) {
                    List {
                        Text(viewModel.detail?.instructions ?? "")
                    }
                }
            }
            .navigationTitle(viewModel.dessert.name)
        }
    }
}
