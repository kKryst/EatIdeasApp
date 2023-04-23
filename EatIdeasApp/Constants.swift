//
//  Constants.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 11/03/2023.
//

import Foundation
import UIKit


struct K {
    struct Segues {
        static let fromSavedToDetails = "goToDetailsFromSaved"
        static let fromMainToDetails = "goToDetails"
        
    }
}


extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


extension UILabel {
    func hideSkeletonFixed(label: UILabel) {
        let textToPersist = label.text!
        label.hideSkeleton()
        label.text! = textToPersist
    }
    
}
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


class LogOutUIButton: UIButton {
    
    func presentLogoutAlert (authenticator: FirebaseAuthenticator, view: UIViewController) {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes, I want to log out"), style:.default, handler: { _ in
            authenticator.logOutUser()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No, I do not want to log out"), style:.default, handler: { _ in
        
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
}
