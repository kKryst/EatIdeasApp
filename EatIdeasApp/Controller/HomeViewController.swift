//
//  ViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 29/12/2022.
//

import UIKit
import SwipeCellKit
import SkeletonView




class HomeViewController: UIViewController {
    
    
#warning("TODO: sketelonView on the main tableView")
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dishesFromIngridientsTableView: UITableView!
    
    // An instance of RandomManager that is responsible for fetching data from an API
    
    var randomManager = RandomManager()
    
    // Arrays that store data for table views
    var ingridients: [String] = [String]()
    var dishes : [RandomModel] = []
    
    @IBOutlet weak var logoutBackground: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        tableView.rowHeight = 144
        tableView.isSkeletonable = true
        tableView.showSkeleton(usingColor: .silver, transition: .crossDissolve(0.25))
        
        randomManager.delegate = self
        randomManager.fetchDishes()
        
        logoutBackground.layer.cornerRadius = 15.0
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailsViewController = segue.destination as! DetailVC
        let selectedCell = sender
        
        let indexPath = tableView.indexPath(for: selectedCell as! UITableViewCell)
        let row = indexPath!.row
        
        detailsViewController.recipeId = dishes[row].id
        detailsViewController.segueIdentifier = segue.identifier!
        
    }
}
//MARK: tableView DataSource extension

extension HomeViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath) as! TestTableViewCell
        
        let dishTitle =  dishes[indexPath.row].name
        
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
        let imageUrlString = dishes[indexPath.row].image
        
        //set cell's image
        setCellImage(imageUrlString, cell)
        
        //zawijanie wierszy w komorce
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
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
        } else if tableView == self.dishesFromIngridientsTableView {
            let selectedCell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "goToDetailsFromDishesByIngridients", sender: selectedCell)
        }
        
    }
    
}
//MARK: RandomManagerDelegate Extension
extension HomeViewController : RandomManagerDelegate {
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]) {
        
        self.dishes.removeAll()
        
        DispatchQueue.main.async {
            for item in returned {
                self.dishes.append(item)
            }
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
        
}


