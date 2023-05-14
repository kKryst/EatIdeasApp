//
//  RecipeInstructionRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 30/03/2023.
//

import Foundation
import RealmSwift

class RecipeInstructionRealmModel: Object {
    // id related to the dish
    @Persisted var dishApiId: Int
    // step's description
    @Persisted var descriptionString: String
    // number of given step
    @Persisted var step: Int
    // list of ingridients
    @Persisted var ingridients: List<String>
    
    init(stepData: Step, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.descriptionString = stepData.step
        self.step = stepData.number
        // table of ingridients from data
        var ingridients: List<String> = List<String>()
        // if given data is not nil
        if let safeIngridients = stepData.ingredients {
            // for each ingridient add step's name into the array of strings
            for safeItem in safeIngridients {
                ingridients.append(safeItem.name)
            }
        }
        // if table created to contain ingridient's name from the Data is empty, return an empty array of string
        if ingridients.isEmpty {
            self.ingridients = List<String>()
        // if not, return the array of recieved ingridients
        } else {
            self.ingridients = ingridients
        }
    }
    
    init(descriptionString: String, step: Int, ingridients: List<String>, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.descriptionString = descriptionString
        self.step = step
        self.ingridients = ingridients
    }
    
    init(model: RecipeInstructionModel, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.descriptionString = model.description
        self.step = model.step
        var tempIng: List<String> = List<String>()
        
        for item in model.ingridients {
            tempIng.append(item)
        }
        
        self.ingridients = tempIng
    }
    
    override init() {
        super.init()
    }
    
    
}
