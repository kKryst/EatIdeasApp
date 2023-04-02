//
//  DishRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/01/2023.
//

import Foundation
import RealmSwift

class DishRealmModel: Object {
    @Persisted var dishApiId: Int
    @Persisted var title: String
    @Persisted var image: String
    @Persisted var readyInMinutes: Int
    @Persisted var diaryFree: String
    @Persisted var glutenFree: String
    @Persisted var vegan: String
    @Persisted var vegetarian: String
    @Persisted var extendedIngridients: List<RealmIngredient>
    
    
    
    init(dishApiId: Int, title: String, image: String, readyInMinutes: Int, diaryFree: String, glutenFree: String, vegan: String, vegetarian: String, extendedIngridients: List<RealmIngredient>) {
        self.dishApiId = dishApiId
        self.title = title
        self.image = image
        self.readyInMinutes = readyInMinutes
        self.diaryFree = diaryFree
        self.glutenFree = glutenFree
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.extendedIngridients = extendedIngridients
        
        
        
        
    }
    
    override init() {
        super.init()
    }
    
    init(model: DishModel) {
        self.dishApiId = model.id
        self.title = model.title
        self.image = model.image
        self.readyInMinutes = model.readyInMinutes
        self.diaryFree = model.diaryFreeString
        self.glutenFree = model.glutenFreeString
        self.vegan = model.veganString
        self.vegetarian = model.vegetarianString
        
        var ingridients: List<RealmIngredient> = List<RealmIngredient>()
        for ingridient in model.extendedIngredients {
            ingridients.append(RealmIngredient(ingridient))
        }
        self.extendedIngridients = ingridients
    }
    
}

