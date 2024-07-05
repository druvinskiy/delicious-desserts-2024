//
//  Dessert.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import Foundation

/// Represents a JSON response containing an array of desserts.
///
/// Expected payload:
///
/// ```json
/// {
/// "meals": [
///  {
///   "strMeal": "Apam balik",
///   "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
///   "idMeal": "53049"
///  },
///  {
///   "strMeal": "Apple & Blackberry Crumble",
///   "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
///   "idMeal": "52893"
///  }
/// ]
///}
/// ```
struct DessertResponse: Decodable {
    let meals: [Dessert]
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
}

struct Dessert: Decodable, Comparable, Identifiable {
    let name: String
    let thumbnailUrl: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnailUrl = "strMealThumb"
        case id = "idMeal"
    }
    
    init(id: String) {
        self.name = ""
        self.thumbnailUrl = ""
        self.id = id
    }
    
    static func < (lhs: Dessert, rhs: Dessert) -> Bool {
        return lhs.name < rhs.name
    }
}
