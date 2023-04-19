//
//  RegisterVC.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 13/04/2023.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let authenticator = FirebaseAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.isHidden = true
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        authenticator.registerNewUser(email: emailTextField.text, password: passwordTextField.text) { response in
            if response.authResult {
                self.dismiss(animated: true)
                print("account created")
            } else {
                self.errorLabel.text = response.error
                self.errorLabel.isHidden = false
            }
        }
        
        
    }
}


