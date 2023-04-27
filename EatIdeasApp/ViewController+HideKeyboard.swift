//
//  ViewController+HideKeyboard.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 27/04/2023.
//

import Foundation
import UIKit


// functionality to hide keyboard when touching outside of it
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
