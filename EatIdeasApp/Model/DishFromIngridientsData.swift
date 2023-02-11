//
//  DishFromIngridientsData.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 09/02/2023.
//

import Foundation

// MARK: - DishFromIngridientsData
struct DishFromIngridientsData: Codable {
    let id: Int
    let image: String
    let imageType: String
    let likes, missedIngredientCount: Int
    let missedIngredients: [Ingridient]
    let title: String
    let unusedIngredients: [Ingridient]
    let usedIngredientCount: Int
    let usedIngredients: [Ingridient]
}

// MARK: - SedIngredient
struct Ingridient: Codable {
    let aisle: String
    let amount: Double
    let id: Int
    let image: String
    let meta: [String]
    let name, original, originalName, unit: String
    let unitLong, unitShort: String
    let extendedName: String?
}
