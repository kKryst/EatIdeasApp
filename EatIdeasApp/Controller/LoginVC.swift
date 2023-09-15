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
    
    let authenticator = FirebaseAuthenticatorManager()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var passedEmail, passedPassword: String?
    var error: String?
    var accountCreated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    @IBAction func registerHereButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goFromLoginToRegister", sender: self)
    }
    
    
    @IBAction func logInWithGoogle(_ sender: Any) {
        Task {
            await authenticator.signInWithGoogle()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BarColor")
        errorLabel.isHidden = true
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        authenticator.logInUser(email: emailTextField.text, password: passwordTextField.text) { response in
            if response.authResult {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.errorLabel.text = response.error
                self.errorLabel.isHidden = false
            }
        }
    }
}


extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
