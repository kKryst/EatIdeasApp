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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BarColor")
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
 
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        authenticator.registerNewUser(email: emailTextField.text, password: passwordTextField.text) { response in
            if response.authResult {
                if let navigationController = self.navigationController {
                    for viewController in navigationController.viewControllers {
                        if viewController is HomeViewController {
                            navigationController.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
            } else {
                self.errorLabel.text = response.error
                self.errorLabel.isHidden = false
            }
        }
    }
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}


