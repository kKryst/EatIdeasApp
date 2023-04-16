//
//  LoginVC.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 13/04/2023.
//

import Foundation
import UIKit
import FirebaseAuth

// TODO: green color after hiding tab bar

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func registerHereButtonPressed(_ sender: UIButton) {
//        let presentedView = self
//        presentedView.dismiss(animated: true)
        performSegue(withIdentifier: "goFromLoginToRegister", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BarColor")
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("succesfully logged in \(authResult?.user.email)")
                    self.dismiss(animated: true)
                }
                
            }
        }
        
        
    }
    
    
    
}
