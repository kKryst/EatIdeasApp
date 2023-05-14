//
//  LogoutUIButton.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 27/04/2023.
//

import Foundation
import UIKit

class LogoutUIButton: UIButton {
    
    func presentLogoutAlert (authenticator: FirebaseAuthenticatorManager, view: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes, I want to log out"), style:.default, handler: { _ in
            authenticator.logOutUser()
            completion()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No, I do not want to log out"), style:.default, handler: { _ in
        
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    func swapImage(image: UIImage){
        self.setBackgroundImage(image, for: .normal)
    }
    
    func swapImage() {
        if let safePersonImage = UIImage(systemName: "person") {
            if let safeRectangleImage = UIImage(systemName: "") {
                if self.currentBackgroundImage == safeRectangleImage {
                    self.setBackgroundImage(safePersonImage, for: .normal)
                } else {
                    self.setBackgroundImage(safeRectangleImage, for: .normal)
                }
            }
                
        }
    }
    
    func setImageBasedOnStatus(isLogged: Bool) {
        if isLogged {
            if let safeLogoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right") {
                self.setBackgroundImage(safeLogoutImage, for: .normal)
            }
        } else {
            if let safePersonImage = UIImage(systemName: "person") {
                self.setBackgroundImage(safePersonImage, for: .normal)
            }
        }
    }
    
}
