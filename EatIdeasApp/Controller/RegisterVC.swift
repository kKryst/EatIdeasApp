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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("ERROR OCCURED: \(e.localizedDescription)")
                } else {
                    self.dismiss(animated: true)
                }
                
                
                
            }
        }
        
        
    }
    

}
