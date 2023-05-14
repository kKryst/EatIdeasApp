//
//  RecipeInstructions.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/03/2023.


import Foundation

// MARK: - RecipeInstruction
//API will always send an array of recipeinstructions, even if there will be only one recipe instruction
struct RecipeInstrucrionData: Codable {
    //name of what this recipe is about (ie. SASUAGE, PASTA, butter, etc.)
    let name: String
    // each step in current category: sasuage, addons, etc.
    let steps: [Step]
}

// MARK: - Step
// step represents e ach step in the recipe including ingridients required for given step
struct Step: Codable {
    // equipment for current step and ingridients required
    let equipment, ingredients: [Ent]?
    // numer kroku
    let number: Int
    // description for given step
    let step: String
    
}
// MARK: - Ent
struct Ent: Codable {
    //every step has it's ID
    let id: Int
    // descritpion of every single ingridient needed for given step and photo's url
    let image, name: String
}
