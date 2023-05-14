//
//  RecipeInstructionModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/03/2023.
//

import Foundation


struct RecipeInstructionModel{
    
    // step's description
    let description: String
    // number of given step
    let step: Int
    // list of ingridients
    let ingridients: [String]
    
    
    
    init(description: String, step: Int, ingridients: [String]) {
        self.description = description
        self.step = step
        self.ingridients = ingridients
    }
    init(stepData: Step) {
        self.description = stepData.step
        self.step = stepData.number
        // table of ingridients from data
        var ingridients: [String] = [String]()
        // if given data is not nil
        if let safeIngridients = stepData.ingredients {
            // for each ingridient add step's name into the array of strings
            for safeItem in safeIngridients {
                ingridients.append(safeItem.name)
            }
        }
        // if table created to contain ingridient's name from the Data is empty, return an empty array of string
        if ingridients.isEmpty {
            self.ingridients = [String]()
        // if not, return the array of recieved ingridients
        } else {
            self.ingridients = ingridients
        }
    }
    
    init(dbModel: RecipeInstructionRealmModel) {
        self.description = dbModel.descriptionString
        self.step = dbModel.step
        
        var tempIng: [String] = [String]()
        
        for item in dbModel.ingridients {
            tempIng.append(item)
        }
        
        self.ingridients = tempIng
    }
}
