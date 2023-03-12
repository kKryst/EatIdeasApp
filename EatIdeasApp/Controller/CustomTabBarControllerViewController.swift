//
//  CustomTabBarControllerViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 11/03/2023.
//

import UIKit

class CustomTabBarControllerViewController: UITabBarController {
    
    @IBInspectable var initialIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = initialIndex
        
        // Do any additional setup after loading the view.
    }

}
