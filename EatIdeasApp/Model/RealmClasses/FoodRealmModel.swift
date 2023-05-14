//
//  FoodRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 30/03/2023.

import Foundation
import RealmSwift


#warning("do kazdego elementu dodac dishApiId, by powiązać ze sobą elementy i móc je później usuwać / PODODAWAĆ ID do każdego elementu kurwa jego mac")
class FoodRealmModel: Object {
    @Persisted var dishApiId: Int
    @Persisted var dish: DishRealmModel?
    @Persisted var recipes: List<RecipeInstructionRealmModel> = List()
    
    
    init(recipeID: Int, dish: DishRealmModel, recipes: List<RecipeInstructionRealmModel>) {
        self.dishApiId = recipeID
        self.dish = dish
//        
//        let tempReicpes: List<RecipeInstructionRealmModel?> = List<RecipeInstructionRealmModel?>()
//        
//        for item in recipes{
//            tempReicpes.append(item)
//        }
        self.recipes = recipes
    }

    override init() {
        super.init()
    }
    
}
