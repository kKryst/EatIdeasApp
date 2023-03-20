//
//  RealmIngridients.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 19/03/2023.
//

import Foundation
import RealmSwift


class RealmIngredient: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var measures: RealmMeasures?
    
    
    init(_ ingridients: ExtendedIngredient) {
        self.id = ingridients.id
        self.name = ingridients.name
        self.measures = RealmMeasures(ingridients.measures)
    }
    override init() {
        super.init()
    }
}

class RealmMeasures: Object {
    @Persisted var metric: RealmMetric?
    @Persisted var us: RealmMetric?
    
    init(_ measure: Measures) {
        self.metric = RealmMetric(measure.metric)
        self.us = RealmMetric(measure.us)
    }
    
    //simplified constructor
    init(value: Double, unit: String) {
        self.metric = RealmMetric(amount: value, unitLong: unit, unitShort: unit)
        self.us = RealmMetric(amount: value, unitLong: unit, unitShort: unit)
    }
    
    //basic constructor
    override init(){
        super.init()
    }
}

class RealmMetric: Object {
    @Persisted var amount: Double
    @Persisted var unitLong: String
    @Persisted var unitShort: String
    
    init(_ metric: Metric) {
        self.amount = metric.amount
        self.unitLong = metric.unitLong
        self.unitShort = metric.unitShort
    }
    
    override init() {
        super.init()
    }
    
    init(amount: Double, unitLong: String, unitShort: String){
        self.amount = amount
        self.unitShort = unitShort
        self.unitLong = unitLong
    }
}
