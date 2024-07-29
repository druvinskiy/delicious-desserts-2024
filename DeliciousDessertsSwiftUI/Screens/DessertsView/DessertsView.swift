//
//  DessertsView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/26/24.
//

import SwiftUI

struct DessertsView: View {
    enum LoadingState {
        case loading
        case data(DessertsViewModel)
        case error(Error)
    }
    
    @State private var loadingState: LoadingState = .loading
    @EnvironmentObject var networkManager: DessertNetworkManager
    
    var body: some View {
        NavigationView {
            switch loadingState {
            case .loading:
                LoadingView()
            case .data(let viewModel):
                DessertsScrollView(viewModel: viewModel)
            case .error(let error):
                ErrorView(message: error.localizedDescription)
                    .overlay {
                        Button("Retry") {
                            fetchDesserts()
                        }
                        .offset(y: 150)
                    }
            }
        }
        .task {
            fetchDesserts()
        }
    }
    
    func fetchDesserts() {
        Task {
            do {
                let desserts = try await networkManager.fetchDesserts()
                let viewModel = DessertsViewModel(desserts: desserts)
                
                loadingState = .data(viewModel)
            } catch {
                loadingState = .error(error)
            }
        }
    }
}

struct DessertsScrollView: View {
    let viewModel: DessertsViewModel
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.desserts) { dessert in
                    NavigationLink(destination: DessertDetailView(dessert: dessert)) {
                        DessertCell(dessert: dessert)
                    }
                    .buttonStyle(.cardButtonStyle)
                }
            }
            .navigationTitle(String(localized: "desserts-view.navigation-item.title"))
        }
        .padding(.horizontal, 10)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(scaleSize(isPressed: configuration.isPressed))
            .animation(.linear, value: configuration.isPressed)
        
    }
    
    func scaleSize(isPressed: Bool) -> CGSize {
        let size: CGFloat = isPressed ? 0.96 : 1
        
        return .init(width: size, height: size)
    }
}

extension ButtonStyle where Self == CardButtonStyle {
    static var cardButtonStyle: Self { .init() }
}

#Preview {
    DessertsView()
}
