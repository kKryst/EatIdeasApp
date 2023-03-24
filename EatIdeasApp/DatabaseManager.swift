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
    

    func addToDatabase (dish: DishRealmModel) {
        do {
            try realm.write {
                realm.add(dish)
            }
        } catch {
            print("error trying to add object to database \(error)")
        }

    }

    #warning("TODO: inside this function check for data deduplication")
    // sample code:
    // Check if a person with the same email already exists in the database
//    if let existingPerson = realm.objects(Person.self).filter("email = %@", person.email).first {
//        // A person with the same email already exists, so use the existing object
//        person = existingPerson
//    } else {
//        // No matching person found, so save the new object to the database
//        try! realm.write {
//            realm.add(person)
//        }
//    }
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
                let item = realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first
                if let itemToDelete = item {
                    realm.delete(itemToDelete)
                }
            }
        } catch {
            print ("error while trying to delete item \(error)")
        }
    }
//   should return nil in case there is no such item"
    func fetchObject(id: Int) -> DishRealmModel{
         return realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first!

    }

    func isObjectSaved(id: Int) -> Bool{
        let result = realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first

        if result != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchSaved() -> Results<DishRealmModel> {
        return realm.objects(DishRealmModel.self).sorted(byKeyPath: "title", ascending: true)
    }

}
