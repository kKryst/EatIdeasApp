//
//  DatabaseManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 15/03/2023.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to create Realm instance: \(error)")
        }
    }
    
    func addToDatabase (food: FoodRealmModel) {
        do {
            try realm.write {
                realm.add(food)
            }
        } catch {
            print("error trying to add object to database \(error)")
        }

    }

    func createInDatabase(dish: DishRealmModel) {
        do {
            try realm.write {
                realm.create(type(of: dish), value: dish)
            }
        } catch {
            print("error trying to create an object in database \(error)")
        }
    }
    
    func deleteFromDatabase (id: Int) {
        do {
            try realm.write {
                let item = realm.objects(FoodRealmModel.self).filter("dishApiId == \(id)").first
                if let itemToDelete = item {
                    realm.delete(itemToDelete)
                }
                let dishItem = realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first
                if let itemToDelete = dishItem {
                    realm.delete(itemToDelete)
                }
            }
        } catch {
            print ("error while trying to delete item \(error)")
        }
    }
//   should return nil in case there is no such item"
    func fetchObject(id: Int) -> FoodRealmModel{
         return realm.objects(FoodRealmModel.self).filter("dishApiId == \(id)").first!

    }

    func isObjectSaved(id: Int) -> Bool{
        let result = realm.objects(FoodRealmModel.self).filter("dishApiId == \(id)").first

        if result != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchSaved() -> Results<DishRealmModel> {
        return realm.objects(DishRealmModel.self).sorted(byKeyPath: "title", ascending: true)
        
        
    }
    
    func fetchRecipes(recipeId: Int) -> List<RecipeInstructionRealmModel> {
        return realm.objects(FoodRealmModel.self).filter("dishApiId == \(recipeId)").first!.recipes
    }

}
