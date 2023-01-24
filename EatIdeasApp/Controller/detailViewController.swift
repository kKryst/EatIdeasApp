//
//  DetailViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 15/01/2023.
//

import Foundation
import UIKit


class DetailViewController : UIViewController {
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        randomManager.fetchSpecificDisch(id: recipeId)
        
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        //TODO: future coreData feature which saves the dish once user presses this button
        favouriteButton.currentBackgroundImage == UIImage(systemName: "heart") ? favouriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal) :   favouriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
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
        
        
        //TODO: NOT secure at all, fix that later
        let url = URL(string: returned.image)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        DispatchQueue.main.async {
            self.idText.text = returned.title
            self.readyInLabel.text?.append(String(returned.readyInMinutes))
            self.dishImage.image = UIImage(data: data!)
            self.lactoseFreeLabel.text?.append(returned.diaryFreeString)
            self.glutenFreeLabel.text?.append(returned.glutenFreeString)
            self.veganLabel.text?.append(returned.veganString)
            self.vegetarianLabel.text?.append(returned.vegetarianString)
            
            for item in returned.extendedIngridientsString {
                self.ingridients.append(item)
            }
            
            self.tableView.reloadData()
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
        //
    }
    
}
