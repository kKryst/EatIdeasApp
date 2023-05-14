//
//  RealmMeasures.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 12/05/2023.
//

import Foundation
import RealmSwift

class RealmMeasures: Object {
    @Persisted var dishApiId: Int
    @Persisted var metric: RealmMetric?
    @Persisted var us: RealmMetric?
    
    init(_ measure: Measures, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.metric = RealmMetric(measure.metric, dishApiId: dishApiId)
        self.us = RealmMetric(measure.us, dishApiId: dishApiId)
    }
    
    //simplified constructor
    init(value: Double, unit: String, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.metric = RealmMetric(amount: value, unitLong: unit, unitShort: unit, dishApiId: dishApiId)
        self.us = RealmMetric(amount: value, unitLong: unit, unitShort: unit, dishApiId: dishApiId)
    }
    
    //basic constructor
    override init(){
        super.init()
    }
}
