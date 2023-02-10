//
//  DishFromIngridientsModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 09/02/2023.
//

import Foundation


struct DishFromIngridientsModel {
    let id: Int
    let image: String
    let missedIngridients: [Ingridient]
    let title: String
    let unusedIngridients: [Ingridient]
    let usedIngridients: [Ingridient]
    
    var missedIngridientsString: [String] {
        var names: [String] = [String]()
        
        for item in missedIngridients {
            names.append(item.name)
        }
        return names
    }
    
    var unusedIngridientsString: [String] {
        var names: [String] = [String]()
        
        for item in unusedIngridients {
            names.append(item.name)
        }
        return names
    }
    
    var usedIngridientsString: [String] {
        var names: [String] = [String]()
        
        for item in usedIngridients {
            names.append(item.name)
        }
        return names
    }
    
    
}
