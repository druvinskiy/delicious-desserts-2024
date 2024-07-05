//
//  DessertsView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/26/24.
//

import SwiftUI

struct DessertsView: View {
    @StateObject var viewModel = DessertsViewModel()
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        Group {
            if let errorString = viewModel.errorString {
                ErrorView(message: errorString)
            } else if viewModel.isLoading {
                LoadingView()
            } else {
                NavigationView {
                    dessertsScrollView
                }
            }
        }
        .onAppear {
            viewModel.fetchDesserts()
        }
    }
    
    private var dessertsScrollView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.desserts) { dessert in
                    let detailViewModel = DessertDetailViewModel(dessert: dessert)
                    
                    NavigationLink(destination: DessertDetailView(viewModel: detailViewModel)) {
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
