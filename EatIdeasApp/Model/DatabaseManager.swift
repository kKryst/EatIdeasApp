//
//  DatabaseManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 15/03/2023.
//

import Foundation
import RealmSwift



class DatabaseManager {
    
    //singleton that controls talking to the database
    static let shared = DatabaseManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to create Realm instance: \(error)")
        }
    }

    func addToDatabase(food: FoodRealmModel) {
        if food.isInvalidated {
            self.createInDatabase(food: food)
        } else {
            do {
                try realm.write {
                    realm.add(food)
                }
            } catch {
                print("error trying to add object to database \(error)")
            }
        }
    }
    
    private func createInDatabase(food: FoodRealmModel) {
        do {
            try realm.write {
                realm.create(type(of: food), value: food)
            }
        } catch {
            print("error trying to create an object in database \(error)")
        }
    }

    //TODO: dodać kaskadowe usuwanie elementów 
    func deleteFromDatabase (id: Int) {
        do {
            try realm.write {
                // delete all objects associated with dish's id
                let item = realm.objects(FoodRealmModel.self).filter("dishApiId == \(id)").first
                if let itemToDelete = item {
                    realm.delete(itemToDelete)
                }
                let dishItem = realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first
                if let itemToDelete = dishItem {
                    realm.delete(itemToDelete)
                }
                
                let ingridients = realm.objects(RealmIngredient.self).filter("dishApiId == \(id)")
                for ingridient in ingridients {
                    realm.delete(ingridient)
                }
                let measuers = realm.objects(RealmMeasures.self).filter("dishApiId == \(id)")
                for measure in measuers {
                    realm.delete(measure)
                }
                
                let metrics = realm.objects(RealmMetric.self).filter("dishApiId == \(id)")
                for metric in metrics {
                    realm.delete(metric)
                }
                
                let instructions = realm.objects(RecipeInstructionRealmModel.self).filter("dishApiId == \(id)")
                for instruction in instructions {
                    realm.delete(instruction)
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
