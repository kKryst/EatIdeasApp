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
    
    var randomManager = RandomManager()

    
    override func viewDidLoad() {
        randomManager.delegate = self
        randomManager.fetchSpecificDisch(id: recipeId)
    }
    
    
    
}

extension DetailViewController : RandomManagerDelegate {
    func didRecieveSpecificDish(_ randomManager: RandomManager, model: DishModel) {
        DispatchQueue.main.async {
            self.idText.text = model.title
        }
        
    }
    
    func didRecieveDishes(_ randomManager: RandomManager, model: [RandomModel]) {
        
        //
        
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
    
}
