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
    
    
    var randomManager = RandomManager()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        randomManager.fetchSpecificDisch(id: recipeId)
        
    }
}
extension DetailViewController : RandomManagerDelegate {
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel) {
        DispatchQueue.main.async {
            self.idText.text = returned.title
            self.readyInLabel.text?.append(String(returned.readyInMinutes))
            self.lactoseFreeLabel.text?.append(returned.diaryFreeString)
            self.glutenFreeLabel.text?.append(returned.glutenFreeString)
            self.veganLabel.text?.append(returned.veganString)
            self.vegetarianLabel.text?.append(returned.vegetarianString)
            
            for item in returned.extendedIngridientsString {
                self.extendedIngridientsLabel.text?.append(item)
            }
                    
            
        }
        
    }
    
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]) {
        
        //
        
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
    
}
