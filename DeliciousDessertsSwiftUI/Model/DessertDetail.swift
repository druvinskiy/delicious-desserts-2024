//
//  DessertDetail.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import Foundation

/// Represents a JSON response containing an array of dessert details.
///
/// Expected payload:
///
/// ```json
/// {
/// "meals": [
///  {
///   "strInstructions": "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
///   "strIngredient1": "Milk",
///   "strIngredient2": "Oil",
///   "strIngredient1": "Eggs",
///   "strMeasure1": "200ml"
///   "strMeasure2": "60ml"
///   "strMeasure3": "2",
///  }
/// ]
///}
/// ```
struct DetailsResponse: Decodable {
    let detailsArray: [DessertDetail]
    
    enum CodingKeys: String, CodingKey {
        case detailsArray = "meals"
    }
}

/// Instructions and ingredients for a dessert.
///
/// Expected payload:
/// ```json
/// {
///  "strInstructions": "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
///  "strIngredient1": "Milk",
///  "strIngredient2": "Oil",
///  "strIngredient1": "Eggs",
///  "strMeasure1": "200ml"
///  "strMeasure2": "60ml"
///  "strMeasure3": "2"
/// }
/// ```
///
/// The JSON will contain other properties, but they are not needed.
struct DessertDetail: Decodable {
    let instructions: String
    let ingredients: [Ingredient]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dynamicCodingKeyContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        instructions = try container.decode(String.self, forKey: .instructions)
        ingredients = try DessertDetail.parseIngredients(from: dynamicCodingKeyContainer)
    }
    
    enum CodingKeys: String, CodingKey {
        case instructions = "strInstructions"
    }
    
    private struct DynamicCodingKeys: CodingKey, Comparable {
        var stringValue: String
        var intValue: Int?
        
        enum DetailType: String {
            case ingredient = "strIngredient"
            case measurement = "strMeasure"
            
            var prefix: String {
                return self.rawValue
            }
            
            static func from(_ stringValue: String) -> DetailType? {
                if stringValue.starts(with: DetailType.ingredient.rawValue) {
                    return .ingredient
                } else if stringValue.starts(with: DetailType.measurement.rawValue) {
                    return .measurement
                } else {
                    return nil
                }
            }
        }
        
        var type: DetailType
        
        init?(stringValue: String) {
            guard let type = DetailType.from(stringValue) else { return nil }
            
            self.type = type
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        var isIngredient: Bool {
            return type == .ingredient
        }
        
        var isMeasurement: Bool {
            return type == .measurement
        }
        
        static func < (lhs: DynamicCodingKeys, rhs: DynamicCodingKeys) -> Bool {
            if let lhsNumber = lhs.numberFromStringValue,
               let rhsNumber = rhs.numberFromStringValue {
                
                return lhsNumber < rhsNumber
            }
            
            return lhs.stringValue < rhs.stringValue
        }
        
        private var numberFromStringValue: Int? {
            guard let range = stringValue.range(of: type.prefix) else { return nil }
            let numberString = stringValue[range.upperBound...]
            return Int(numberString)
        }
    }
    
    /// Ingredients and measurements for a meal are represented by a parallel set of fields in the JSON
    /// named "strIngredient1", "strIngredient2", "strIngredient3" and "strMeasure1", "strMeasure2", "strMeasure1".
    /// "strIngredient1" needs to be connected to "strMeasure1",  "strIngredient2" needs to be connected to "strMeasure2", etc.
    ///
    /// If an ingredient does not have a corresponding measurement, an error is thrown.
    ///
    /// - Parameter container: The container of ingredients, measurements, and other details about a meal.
    /// - Returns: An ``[Ingredient]`` containing the connected ingredients and measurements.
    private static func parseIngredients(from container: KeyedDecodingContainer<DessertDetail.DynamicCodingKeys>) throws -> [Ingredient] {
        
        let ingredientKeys = container.allKeys
            .filter({ $0.isIngredient })
            .sorted()
        
        let ingredientNames = try ingredientKeys.compactMap({ key in
            let ingredientName = try container.decodeIfPresent(String.self, forKey: key)
            return ingredientName?.lowercased().trimmingCharacters(in: .whitespaces)
        })
            .filter({ !$0.isEmpty })
        
        let measurementKeys = container.allKeys
            .filter({ $0.isMeasurement })
            .sorted()
        
        let ingredientMeasurements = try measurementKeys.compactMap({ key in
            let ingredientMeasure = try container.decodeIfPresent(String.self, forKey: key)
            return ingredientMeasure?.trimmingCharacters(in: .whitespaces)
        })
            .filter({ !$0.isEmpty })
        
        guard ingredientNames.count == ingredientMeasurements.count else {
            throw DDError.invalidData()
        }
        
        var ingredients = [Ingredient]()
        
        for (name, measurement) in zip(ingredientNames, ingredientMeasurements) {
            let ingredient = Ingredient(name: name, measurement: measurement)
            ingredients.append(ingredient)
        }
        
        return ingredients
    }
}

struct Ingredient: Identifiable, Equatable {
    var id = UUID()
    let name: String
    let measurement: String
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.measurement == rhs.measurement
    }
}
