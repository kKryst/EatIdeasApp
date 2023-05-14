//
//  RealmMetric.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 12/05/2023.
//

import Foundation
import RealmSwift

class RealmMetric: Object {
    @Persisted var dishApiId: Int
    @Persisted var amount: Double
    @Persisted var unitLong: String
    @Persisted var unitShort: String
    
    init(_ metric: Metric, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.amount = metric.amount
        self.unitLong = metric.unitLong
        self.unitShort = metric.unitShort
    }
    
    override init() {
        super.init()
    }
    
    init(amount: Double, unitLong: String, unitShort: String, dishApiId: Int){
        self.dishApiId = dishApiId
        self.amount = amount
        self.unitShort = unitShort
        self.unitLong = unitLong
    }
}
