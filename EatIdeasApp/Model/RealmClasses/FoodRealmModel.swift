//
//  FoodRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 30/03/2023.

import Foundation
import RealmSwift


class FoodRealmModel: Object {
    @Persisted var dishApiId: Int
    @Persisted var dish: DishRealmModel?
    @Persisted var recipes: List<RecipeInstructionRealmModel> = List()
    
    
    init(recipeID: Int, dish: DishRealmModel, recipes: List<RecipeInstructionRealmModel>) {
        self.dishApiId = recipeID
        self.dish = dish
        self.recipes = recipes
    }

    override init() {
        super.init()
    }
    
}
