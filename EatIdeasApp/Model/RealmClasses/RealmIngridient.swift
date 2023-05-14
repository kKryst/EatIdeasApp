//
//  RealmIngridients.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 19/03/2023.
//

import Foundation
import RealmSwift


class RealmIngredient: Object {
    @Persisted var dishApiId: Int
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var measures: RealmMeasures?
    
    
    init(_ ingridients: ExtendedIngredient, dishApiId: Int) {
        self.dishApiId = dishApiId
        self.id = ingridients.id
        self.name = ingridients.name
        self.measures = RealmMeasures(ingridients.measures, dishApiId: dishApiId)
    }
    override init() {
        super.init()
    }
}




