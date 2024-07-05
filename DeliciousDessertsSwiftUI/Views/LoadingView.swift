//
//  LoadingView.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}

#Preview {
    LoadingView()
}
