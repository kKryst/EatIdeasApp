//
//  FirebaseAuthenticator.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 16/04/2023.
//

import Foundation
import FirebaseAuth
import GoogleSignIn


//class to communicate with firebase authentication
struct FirebaseAuthenticatorManager {
    
    func registerNewUser(email: String?, password: String?, completion: @escaping (AuthenticationResponse) -> Void) {
        var response = AuthenticationResponse(authResult: false)
        
        //check if email and password is not nil, if it is, return response with authResult as false
        guard let email = email, let password = password else {
            completion(response)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                response.error = error.localizedDescription
                completion(response)
            } else {
                response.authResult = true
                completion(response)
            }
        }
    }
        
    func logInUser(email: String?, password: String?, completion: @escaping (AuthenticationResponse) -> Void) {
        var response = AuthenticationResponse(authResult: false)

        // check if email and password is not nil, if it is, return response with authResult as false
        guard let email = email, let password = password else {
            completion(response)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                response.error = error.localizedDescription
                completion(response)
            } else {
                response.authResult = true
                completion(response)
            }
        }
    }

    func logOutUser() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("USER SIGNED OUT")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func isAnyUserIsLoggedIn() -> Bool {
        // Check if there's a logged in user
        if Auth.auth().currentUser != nil {
            // User is signed in
            return true
        } else {
            // No user is signed in
            return false
        }
    }
    
    func signInWithGoogle() async {
        
        var loginSuccess = false
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root VC")
            return
        }
        do {
            // o tu to w głównym wątku
            Task.init { @MainActor in
                let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuthentication.user
                
                guard let idToken = user.idToken else {
                    return false
                }
                
                let accessToken = user.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                let result = try await Auth.auth().signIn(with: credential)
                let firebaseUser = result.user
                print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "")")
                return true
            }
        }
    }
    
    func getSignedUserEmail() -> String {
        // Check if there's a logged in user
        if let currentUser = Auth.auth().currentUser {
            // User is signed in
            if let safeUserEmail = currentUser.email {
                print("user's name: \(safeUserEmail)")
                return safeUserEmail
            } else {
                print("Error fetching user's email")
                return "No user"
            }
        } else {
            // No user is signed in
            return "No user"
        }
    }
}

class AuthenticationResponse {
    var error: String?
    var authResult: Bool
    
    init(error: String? = nil, authResult: Bool) {
        self.error = error
        self.authResult = authResult
    }
}
