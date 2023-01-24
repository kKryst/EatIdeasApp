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
    
    
}
