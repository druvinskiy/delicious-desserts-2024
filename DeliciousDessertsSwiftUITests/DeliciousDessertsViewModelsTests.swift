//
//  DeliciousDessertsViewModelsTests.swift
//  DeliciousDessertsSwiftUITests
//
//  Created by David Ruvinskiy on 7/1/24.
//

import XCTest
@testable import DeliciousDessertsSwiftUI

final class DeliciousDessertsViewModelsTests: XCTestCase {
    lazy var bundle = Bundle(for: type(of: self))
    let decoder = JSONDecoder()
    
    func testDessertsViewModel() throws {
        let mockData = bundle.loadData(filename: "DessertResponse")
        let unsortedDesserts = try decoder.decode(DessertResponse.self, from: mockData).meals
        
        let viewModel = DessertsViewModel(desserts: unsortedDesserts)
        let desserts = viewModel.desserts
        
        for (index, dessert) in desserts.enumerated() where index != desserts.count - 1 {
            let next = desserts[index + 1]
            XCTAssertTrue(dessert.name < next.name)
        }
    }
    
    func testDessertDetailViewModel() throws {
        let mockData = bundle.loadData(filename: "ApamBalikDetails")
        let detailsResponse = try decoder.decode(DetailsResponse.self, from: mockData)
        
        if let detail = detailsResponse.detailsArray.first {
            let viewModel = DessertDetailViewModel(detail: detail)
            
            let ingredientStrings = [
                "200ml milk",
                "60ml oil",
                "2 eggs",
                "1600g flour",
                "3 tsp baking powder",
                "1/2 tsp salt",
                "25g unsalted butter",
                "45g sugar",
                "3 tbs peanut butter"
            ]
            
            XCTAssertEqual(viewModel.ingredients, ingredientStrings)
            
            XCTAssertEqual(
                viewModel.instructions,
                "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm."
            )
        } else {
            XCTFail("Expected non-nil detail")
        }
    }
}
