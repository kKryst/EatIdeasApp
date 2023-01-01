//
//  Dish.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 01/01/2023.
//

import Foundation

// MARK: - Response
struct RandomData: Codable {
    let recipes: [Recipe]
}

// MARK: - Recipe
struct Recipe: Codable {
    let id: Int
    let title: String
}








