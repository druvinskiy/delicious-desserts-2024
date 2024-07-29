//
//  DessertsViewModel.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

final class DessertsViewModel: ObservableObject {
    @Published private var dessertsPrivate = [Dessert]()
    
    init(desserts: [Dessert]) {
        self.desserts = desserts
    }
    
    var desserts: [Dessert] {
        get {
            dessertsPrivate.sorted()
        }
        set {
            dessertsPrivate = newValue
        }
    }
}
