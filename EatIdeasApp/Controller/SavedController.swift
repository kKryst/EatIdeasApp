//
//  SavedController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 02/02/2023.
//

import Foundation
import UIKit
import RealmSwift

class SavedController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dishes: Results<DishRealmModel>?
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchSaved()
        
        
    }
}

extension SavedController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Saved", for: indexPath)
        
        cell.textLabel?.text = dishes?[indexPath.row].title ?? "No dishes saved"
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
//MARK: Realm Database related
extension SavedController {

    func fetchSaved() {
        dishes = realm.objects(DishRealmModel.self)
    }
    
    
}
