//
//  DishRealmModel.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 26/01/2023.
//

import Foundation
import RealmSwift

class DishRealmModel: Object {
    @objc dynamic var dishApiId: Int = -1
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var readyInMinutes: Int = -1
    @objc dynamic var diaryFree: String = ""
    @objc dynamic var glutenFree: String = ""
    @objc dynamic var vegan: String = ""
    @objc dynamic var vegetarian: String = ""
    var extendedIngridients = List<String>()
      
}
    
