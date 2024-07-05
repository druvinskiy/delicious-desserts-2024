//
//  ErrorView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(.dessertPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                
                Text(message)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}
