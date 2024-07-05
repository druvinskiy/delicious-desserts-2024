//
//  Bundle+DataLoading.swift
//  DeliciousDessertsSwiftUITests
//
//  Created by David Ruvinskiy on 7/3/24.
//

import Foundation

extension Bundle {
    func loadData(filename: String) -> Data {
        guard let path = self.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file.")
        }
        
        do {
            return try Data(contentsOf: path)
        } catch {
            print("❌ \(error)")
            fatalError("Failed to load the Data.")
        }
    }
}
