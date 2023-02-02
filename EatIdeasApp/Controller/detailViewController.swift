//
//  DetailViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 15/01/2023.
//


// 1. dorzucic do tabeli wartosc bool w ktorej zapisane bedzie czy dany posilek jest zapisany w bazie
// 2. ustawic obrazek podczas wczytywania w zaleznosci od tego czy posilek z danym id jest juz bazie czy nie



import Foundation
import UIKit
import RealmSwift

//TODO: "Can only delete an object from the Realm it belongs to". error while trying to delete object after reloading view, how to fix that shit

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var idText: UILabel!
    
    var recipeId : Int = 0
    
    @IBOutlet weak var readyInLabel: UILabel!
    
    @IBOutlet weak var lactoseFreeLabel: UILabel!
    
    @IBOutlet weak var glutenFreeLabel: UILabel!
    
    @IBOutlet weak var veganLabel: UILabel!
    
    
    @IBOutlet weak var vegetarianLabel: UILabel!
    
    @IBOutlet weak var extendedIngridientsLabel: UILabel!
    
    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    var randomManager = RandomManager()
    
    var ingridients : [String] = [String]()
    
    var displayedDishModel: DishRealmModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        randomManager.fetchSpecificDisch(id: recipeId)
        
        
        
        
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        //TODO: for future coreData feature which saves the dish once user presses this button
        if favouriteButton.currentBackgroundImage == UIImage(systemName: "heart") {
            favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            addToDatabase(dish: displayedDishModel!)
        } else {
            favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            deleteFromDatabase(id: displayedDishModel!.dishApiId)
        }

    }
    
    func getImageFromUrl( with url : String) -> Data? {
        
        var dataToReturn: Data?
        
        let url = URL(string: url)
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { data, response, error in
            if let safeData = try? Data(contentsOf: url!) {
                dataToReturn = safeData
            }
        }
        task.resume()
        
        return dataToReturn
    }
}
extension DetailViewController : RandomManagerDelegate {
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel) {
        
        var imageData: Data = Data()
        let url = URL(string: returned.image)
        let duckUrl = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCiKxne26dHR5WnPaJp3iIYqwgtH7a_d0So8it6JY&s")
        
        if let data = try? Data(contentsOf: url!) {
            imageData = data
        } else {
            imageData = try! Data(contentsOf: duckUrl!)
        }
        
        //TODO: przepisanie danych do zmiennej displayedDishModel celem pozniejszego przeslania go do bazy danych
        
        DispatchQueue.main.async {
            self.idText.text = returned.title
            self.readyInLabel.text?.append(String(returned.readyInMinutes))
            self.dishImage.image = UIImage(data: imageData)
            self.lactoseFreeLabel.text?.append(returned.diaryFreeString)
            self.glutenFreeLabel.text?.append(returned.glutenFreeString)
            self.veganLabel.text?.append(returned.veganString)
            self.vegetarianLabel.text?.append(returned.vegetarianString)
            
            for item in returned.extendedIngridientsString {
                self.ingridients.append(item)
            }
            self.tableView.reloadData()
        }
        
        displayedDishModel = DishRealmModel()
        displayedDishModel?.dishApiId = returned.id
        displayedDishModel?.title = returned.title
        displayedDishModel?.readyInMinutes = returned.readyInMinutes
        displayedDishModel?.image = returned.image
        displayedDishModel?.diaryFree = returned.diaryFreeString
        displayedDishModel?.glutenFree = returned.glutenFreeString
        displayedDishModel?.vegan = returned.veganString
        displayedDishModel?.vegetarian = returned.vegetarianString
        
        for item in returned.extendedIngridientsString {
            displayedDishModel?.extendedIngridients.append(item)
        }
        DispatchQueue.main.async {
            self.objectSaved(id: self.displayedDishModel!.dishApiId) ? self.favouriteButton.setBackgroundImage(UIImage(systemName: "heart"),  for: .normal) : self.favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        
    }
    
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]) {
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
}

extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingridient", for: indexPath)
        cell.textLabel?.text = ingridients[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

//MARK: Realm Database-related
extension DetailViewController {
    
    
    
    
    func addToDatabase (dish: DishRealmModel) {
        do {
            try realm.write {
                realm.add(dish)
            }
        } catch {
            print("error trying to add object to database \(error)")
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
    
    func objectSaved(id: Int) -> Bool{
        let result = realm.objects(DishRealmModel.self).filter("dishApiId == \(id)").first

        if result != nil {
            return false
        } else {
            return true
        }
    }
    }
    

