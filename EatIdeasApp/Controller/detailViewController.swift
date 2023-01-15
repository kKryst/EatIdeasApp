//
//  DetailViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 15/01/2023.
//

import Foundation
import UIKit


class DetailViewController : UIViewController {
    var recipeId : Int = 0
        
    @IBOutlet weak var idText: UILabel!
    
    
    
    override func viewDidLoad() {
        idText.text = String(recipeId)
    }
    
    
    
}
