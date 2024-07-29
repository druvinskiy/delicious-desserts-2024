//
//  DessertDetailViewModel.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

final class DessertDetailViewModel: ObservableObject {
    @Published private var detail: DessertDetail
    
    var ingredients: [String] {
        return detail.ingredients.map { "\($0.measurement) \($0.name)" }
    }
    
    var instructions: String {
        return detail.instructions
    }
    
    init(detail: DessertDetail) {
        self.detail = detail
    }
}
