//
//  SavedController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 02/02/2023.
//

import Foundation
import UIKit
import RealmSwift
import FirebaseAuth


#warning("cover the tableview with a 'No logged in' view if the user is not logged in")


class SavedViewController: UIViewController {
    
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBackground: UIView!
    
    
    @IBOutlet weak var logoutButton: LogoutUIButton!
    
    var dishes: Results<DishRealmModel>?
    
    let authenticator = FirebaseAuthenticatorManager()
    
    @IBOutlet var userLoggedOutView: UIView!
    
    @IBOutlet weak var logoutInLoggedOutViewButton: UIButton!
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        userLoggedOutView.frame = tableView.frame
        
        userLoggedOutView.isHidden = true
        
        logoutBackground.layer.cornerRadius = 15.0
        
        logoutInLoggedOutViewButton.layer.cornerRadius = 8.0
        
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "Saved")
        
        dishes = DatabaseManager.shared.fetchSaved()
        
        topImage.image = UIImage(named: "savedImage")
 
    }
    // method checks if theres an user logged in
    func checkForAuthentication () {
        let status = authenticator.isAnyUserIsLoggedIn()
        if !status {
//           displays extra view that covers tableview with info that there's no logged in user
            self.view.addSubview(userLoggedOutView)
            userLoggedOutView.isHidden = false
            tableView.isHidden = true
        } else {
//            hides the view
            userLoggedOutView.isHidden = true
            tableView.isHidden = false
        }
        // set logoutbutton's image based on status
        logoutButton.setImageBasedOnStatus(isLogged: status)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        checkForAuthentication()
        
        // hide navigation bar on this view
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // display navigation bar when going to next view
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // set cell's image passing cell and url
    fileprivate func setCellImage(_ imageUrlString: String, _ cell: TestTableViewCell) {
        if let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell.displayedImage.image = image
                }
            }.resume()
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: LogoutUIButton) {
        if authenticator.isAnyUserIsLoggedIn() {
            //show logout alert
            logoutButton.presentLogoutAlert(authenticator: authenticator, view: self) {
                self.checkForAuthentication()
            }
        }
        else {
            // jump to login VC
            performSegue(withIdentifier: "goToLoginFromSaved", sender: self)
        }
        
        
    }
    
}

extension SavedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Saved", for: indexPath) as! TestTableViewCell
        
        // checks if object has saved title and image
        if let dish = dishes?[indexPath.row] {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -0.5 // negative value to draw an outline
            ]

            // Create the attributed string with the attributes
            let attributedString = NSAttributedString(string: dish.title, attributes: attributes)
            
            cell.label.attributedText = attributedString
            cell.label.font = UIFont.systemFont(ofSize: 16)
            
            cell.textBackgroundView.backgroundColor = UIColor(named: "pinkCellColor")
            cell.greenImageBackground.backgroundColor = UIColor(named: "pinkCellColor")

            cell.label.numberOfLines = 0
            cell.label.lineBreakMode = NSLineBreakMode.byWordWrapping
            // see if the saved object contains image's url
            if let imageString = dishes?[indexPath.row].image {
                setCellImage(imageString, cell)
            }
        } else {
            cell.label.text = "No dishes saved"
            cell.textBackgroundView.backgroundColor = UIColor(named: "pinkCellColor")
            cell.displayedImage.image = UIImage(systemName: "questionmark.circle")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "goToDetailsFromSaved", sender: selectedCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsFromSaved" {
            let detailsViewController = segue.destination as! DetailVC
            let selectedCell = sender
            
            let indexPath = tableView.indexPath(for: selectedCell as! UITableViewCell)
            let row = indexPath!.row
            
            detailsViewController.recipeId = dishes![row].dishApiId
            detailsViewController.segueIdentifier = segue.identifier!
        }
    }
    
}
//MARK: logoutView functions
extension SavedViewController {
    
    @IBAction func loginFromLogoutViewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromSaved", sender: self)
        userLoggedOutView.isHidden = true
    }
    
}
