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
    
    
    let authenticator = FirebaseAuthenticator()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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
        errorLabel.isHidden = true
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        authenticator.logInUser(email: emailTextField.text, password: passwordTextField.text) { response in
            if response.authResult {
                self.dismiss(animated: true)
                print("logged in succesfully")
            } else {
                self.errorLabel.text = response.error
                self.errorLabel.isHidden = false
            }
        }
    }
    
    
    
}
