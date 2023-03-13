//
//  DishRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/01/2023.
//

import Foundation
import RealmSwift

class DishRealmModel: Object {
    @objc dynamic var dishApiId: Int = -1
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var readyInMinutes: Int = -1
    @objc dynamic var diaryFree: String = ""
    @objc dynamic var glutenFree: String = ""
    @objc dynamic var vegan: String = ""
    @objc dynamic var vegetarian: String = ""
    var extendedIngridients = List<String>()
    
    init(dishApiId: Int, title: String, image: String, readyInMinutes: Int, diaryFree: String, glutenFree: String, vegan: String, vegetarian: String, extendedIngridients: List<String> = List<String>()) {
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
        
        for ingridient in model.extendedIngredients {
            self.extendedIngridients.append(ingridient.name)
        }
    }
      
}
    
