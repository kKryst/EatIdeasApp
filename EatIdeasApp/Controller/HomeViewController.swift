//
//  ViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 29/12/2022.
//

import UIKit
import SkeletonView


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //view represents window which should be displayed when iphone is not connected to the internet
    @IBOutlet var noInternetView: UIView!
    
    // An instance of RandomManager responsible for fetching data from an API
    var randomManager = RandomManager()
    
    let networkManager = NetworkManager()
    
    let authenticator = FirebaseAuthenticator()
    
    // Arrays that store data for table views
    var dishes : [RandomModel]? = []
    
    @IBOutlet weak var logoutBackground: UIView!
    
    @IBOutlet weak var logoutButton: LogoutUIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        verifyUserStatus()
        
        // hide navigation bar on this view
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // display navigation bar when going to next view
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "Dish")
        
        randomManager.delegate = self
        
        setUpLayout()
        
        checkInternetConnection()
    }
    
    func setUpLayout(){
        
        logoutBackground.layer.cornerRadius = 15.0
        
        noInternetView.layer.cornerRadius = 15.0
        noInternetView.frame = tableView.frame
        
        tableView.rowHeight = 144
        tableView.isSkeletonable = true
        tableView.showSkeleton(usingColor: .silver, transition: .crossDissolve(0.25))
        
    }
    func verifyUserStatus () {
        let status = authenticator.isAnyUserIsLoggedIn()
        logoutButton.setImageBasedOnStatus(isLogged: status)
    }
    
    func checkInternetConnection() {
        // check for internet connection and proceed with fetching dishes if the connection is avilable, if not, show view with information
        if networkManager.isConnectedToInternet() {
            noInternetView.isHidden = true
            randomManager.fetchDishes()
            
        } else {
            view.addSubview(noInternetView)
            noInternetView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            if let safeDishes = dishes {
                let detailsViewController = segue.destination as! DetailVC
                let selectedCell = sender
                
                let indexPath = tableView.indexPath(for: selectedCell as! UITableViewCell)
                let row = indexPath!.row
                
                detailsViewController.recipeId = safeDishes[row].id
                detailsViewController.segueIdentifier = segue.identifier!
            }
        }
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        checkInternetConnection()
    }
    
    
    @IBAction func logButtonPressed(_ sender: UIButton) {
        if authenticator.isAnyUserIsLoggedIn() {
            logoutButton.presentLogoutAlert(authenticator: authenticator, view: self) {
                self.verifyUserStatus()
            }
            
        } else {
            // go to Login screens
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
    }
    
    
}
//MARK: tableView DataSource extension

extension HomeViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes?.count ?? 1
        
    }
    // set cell's image by passing cell and url
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath) as! TestTableViewCell
        
        if let safeDishes = dishes?[indexPath.row] {
            
            let dishTitle =  safeDishes.name
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -0.5 // negative value to draw an outline
            ]
            
            // Create the attributed string with the attributes
            let attributedString = NSAttributedString(string: dishTitle, attributes: attributes)
            
            // Assign the attributed string to a label or other text view
            cell.label.attributedText = attributedString
            
            // no idea how to refactor that
            let imageUrlString = safeDishes.image
            
            //set cell's image
            setCellImage(imageUrlString, cell)
            
            //zawijanie wierszy w komorce
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.numberOfLines = 0
            
            
        } else {
            cell.label.text = "No internet connection"
            
        }
        
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Dish"
    }
    
}
//MARK: Tableview delegate extension
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let selectedCell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "goToDetails", sender: selectedCell)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    }
}
//MARK: RandomManagerDelegate Extension
extension HomeViewController : RandomManagerDelegate {
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]) {
        
        var safeDishes: [RandomModel] = []
        DispatchQueue.main.async {
            for item in returned {
                safeDishes.append(item)
            }
            
            self.dishes = safeDishes
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


