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
    
    var missedIngridientsModel: [IngridientModel] {
        var ingridients: [IngridientModel] = []
        for item in missedIngridients {
            ingridients.append(IngridientModel(name: item.name, amount: item.amount, unit: item.unit))
        }
        return ingridients
    }
    
    var unusedIngridientsModel: [IngridientModel] {
        var ingridients: [IngridientModel] = []
        for item in unusedIngridients {
            ingridients.append(IngridientModel(name: item.name, amount: item.amount, unit: item.unit))
        }
        return ingridients
    }
    
    var usedIngridientsModel: [IngridientModel] {
        var ingridients: [IngridientModel] = []
        for item in usedIngridients {
            ingridients.append(IngridientModel(name: item.name, amount: item.amount, unit: item.unit))
        }
        return ingridients
    }
    
    
}

struct IngridientModel {
    let name: String
    let amount: Double
    let unit: String
}
