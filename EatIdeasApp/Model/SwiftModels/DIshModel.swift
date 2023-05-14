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
    let image: String
    let readyInMinutes: Int
    let diaryFree: Bool
    let glutenFree: Bool
    let vegan, vegetarian: Bool
    let extendedIngredients: [ExtendedIngredient]
    
    var glutenFreeString : String {
        switch glutenFree {
        case true:
            return "yes"
        case false:
            return "no"
        }
    }
    
    var diaryFreeString : String {
        switch diaryFree {
        case true:
            return "yes"
        case false:
            return "no"
            
        }
    }
    
    var veganString : String {
        switch vegan {
        case true:
            return "yes"
        case false:
            return "no"
        }
    }
    
    var vegetarianString : String {
        switch vegetarian {
        case true:
            return "yes"
        case false:
            return "no"
        }
    }
    

    var extendedIngridientsString : [String] {
        var names : [String] = [String]()
        
        for item in extendedIngredients {
            names.append("\(item.name) \n")
        }
        
        return names
    }
    
    init(id: Int, title: String, image: String, readyInMinutes: Int, diaryFree: Bool, glutenFree: Bool, vegan: Bool, vegetarian: Bool, extendedIngredients: [ExtendedIngredient]) {
        self.id = id
        self.title = title
        self.image = image
        self.readyInMinutes = readyInMinutes
        self.diaryFree = diaryFree
        self.glutenFree = glutenFree
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.extendedIngredients = extendedIngredients
    }
    
    init(databaseObject: DishRealmModel) {
        self.id = databaseObject.dishApiId
        self.title = databaseObject.title
        self.readyInMinutes = databaseObject.readyInMinutes
        if databaseObject.vegetarian == "yes" {
            self.vegetarian = true
        } else {
            self.vegetarian = false
        }
        if databaseObject.vegan == "yes" {
            self.vegan = true
        } else {
            self.vegan = false
        }
        if databaseObject.glutenFree == "yes" {
            self.glutenFree = true
        } else {
            self.glutenFree = false
        }
        if databaseObject.diaryFree == "yes" {
            self.diaryFree = true
        } else {
            self.diaryFree = false
        }
        self.image = databaseObject.image

        var tempList: [ExtendedIngredient] = [ExtendedIngredient]()
        for item in databaseObject.extendedIngridients {
            tempList.append(ExtendedIngredient(databaseIngridient: item))
        }
        
        self.extendedIngredients = tempList

    }
    
    
}
