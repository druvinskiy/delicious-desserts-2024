//
//  DeliciousDessertsNetworkManagerTests.swift
//  DeliciousDessertsSwiftUITests
//
//  Created by David Ruvinskiy on 6/30/24.
//

import XCTest
@testable import DeliciousDessertsSwiftUI

final class DeliciousDessertsNetworkManagerTests: XCTestCase {
    let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    lazy var networkManager = DessertNetworkManager(urlSession: urlSession)
    lazy var bundle = Bundle(for: type(of: self))
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchDesserts() async throws {
        let mockData = bundle.loadData(filename: "DessertResponse")
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, try Endpoint.meals(category: "Dessert").url)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, mockData)
        }
        
        let desserts = try await networkManager.fetchDesserts()
        
        XCTAssertEqual(desserts.count, 65)
        XCTAssertEqual(desserts[0].name, "Apam balik")
        XCTAssertEqual(desserts[0].thumbnailUrl, "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        XCTAssertEqual(desserts[0].id, "53049")
        
        XCTAssertEqual(desserts[1].name, "Apple & Blackberry Crumble")
        XCTAssertEqual(desserts[1].thumbnailUrl, "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
        XCTAssertEqual(desserts[1].id, "52893")
    }
    
    func testFetchDessertsWithInvalidData() async throws {
        let mockData = """
        {
            "test": [
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, try Endpoint.meals(category: "Dessert").url)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, mockData)
        }
        
        do {
            let _ = try await networkManager.fetchDesserts()
            XCTFail()
        } catch {
            guard let ddError = error as? DDError else {
                XCTFail()
                return
            }
            
            let key = DessertResponse.CodingKeys.meals
            let context = DecodingError.Context(codingPath: [], debugDescription: "")
            
            if case let DDError.invalidData(invalidDataError) = ddError {
                XCTAssertEqual(
                    invalidDataError?.localizedDescription,
                    DecodingError.keyNotFound(key, context).localizedDescription
                )
            } else {
                XCTFail()
            }
        }
    }
    
    func testFetchDetails() async throws {
        let apamBalikData = bundle.loadData(filename: "ApamBalikDetails")
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, try Endpoint.details(id: "53049").url)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, apamBalikData)
        }
        
        let dessert = Dessert(id: "53049")
        let details = try await networkManager.fetchDetails(for: dessert)
        
        XCTAssertEqual(
            details.instructions,
            "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm."
        )
        
        XCTAssertEqual(details.ingredients.count, 9)
        
        let ingredients = [
            ("milk", "200ml"),
            ("oil", "60ml"),
            ("eggs", "2"),
            ("flour", "1600g"),
            ("baking powder", "3 tsp"),
            ("salt", "1/2 tsp"),
            ("unsalted butter", "25g"),
            ("sugar", "45g"),
            ("peanut butter", "3 tbs"),
        ]
        
        for (index, (name, measurement)) in ingredients.enumerated() {
            XCTAssertEqual(
                details.ingredients[index],
                Ingredient(name: name, measurement: measurement)
            )
        }
    }
    
    func testFetchDetailsInvalidData() async throws {
        let apamBalikData = bundle.loadData(filename: "ApamBalikDetailsInvalid")
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, try Endpoint.details(id: "53049").url)
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, apamBalikData)
        }
        
        let dessert = Dessert(id: "53049")
        
        do {
            let _ = try await networkManager.fetchDetails(for: dessert)
            XCTFail()
        } catch {
            guard let ddError = error as? DDError else {
                XCTFail()
                return
            }
            
            guard case DDError.invalidData = ddError else {
                XCTFail()
                return
            }
        }
    }
}

