//
//  DIshModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 16/01/2023.
//

import Foundation


struct DishModel {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let diaryFree: Bool
    let glutenFree: Bool
    let vegan, vegetarian: Bool
    let extendedIngredients: [ExtendedIngredient]
}
