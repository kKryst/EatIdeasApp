//
//  DishManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 16/01/2023.
//



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? JSONDecoder().decode(Response.self, from: jsonData)

import Foundation

// MARK: - Response
struct DishData: Codable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let dairyFree: Bool
    let glutenFree: Bool
    let vegan, vegetarian : Bool
    let extendedIngredients: [ExtendedIngredient]
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable {
    let id: Int
    let name: String
    
}

