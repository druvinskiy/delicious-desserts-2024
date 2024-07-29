//
//  DeliciousDessertsSwiftUIApp.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/26/24.
//

import SwiftUI

@main
struct DeliciousDessertsSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            DessertsView()
                .environmentObject(DessertNetworkManager.shared)
        }
    }
}
