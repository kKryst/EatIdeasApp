//
//  DishManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 16/01/2023.
//

import Foundation

// MARK: - Response
struct DishData: Codable {
    let id: Int
    let title: String
    let image : String
    let readyInMinutes: Int
    let dairyFree: Bool
    let glutenFree: Bool
    let vegan, vegetarian : Bool
    let extendedIngredients: [ExtendedIngredient]
    
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable {
    let id: Int
    let name: String
    let measures: Measures
    
    init(id: Int, name: String, measures: Measures) {
        self.id = id
        self.name = name
        self.measures = measures
    }
    init (databaseIngridient: RealmIngredient) {
        self.id = databaseIngridient.id
        self.name = databaseIngridient.name
        self.measures = Measures(databaseMeasure: databaseIngridient.measures!)
    }
    
}
struct Measures: Codable {
    let metric, us: Metric
    
    init(metric: Metric, us: Metric) {
        self.metric = metric
        self.us = us
    }
    
    init(databaseMeasure: RealmMeasures) {
        self.metric = Metric(databaseMetric: databaseMeasure.metric!)
        self.us = Metric(databaseMetric: databaseMeasure.us!)
    }
    
    //simplified constructor
    init(value: Double, unit: String) {
        self.metric = Metric(amount: value, unitLong: unit, unitShort: unit)
        self.us = Metric(amount: value, unitLong: unit, unitShort: unit)
    }
}

struct Metric: Codable {
    let amount: Double
    let unitLong, unitShort: String

    init(databaseMetric: RealmMetric) {
        self.amount = databaseMetric.amount
        self.unitLong = databaseMetric.unitLong
        self.unitShort = databaseMetric.unitShort
    }
    
    init(amount: Double, unitLong: String, unitShort: String) {
        self.amount = amount
        self.unitLong = unitLong
        self.unitShort = unitShort
    }
    
}


