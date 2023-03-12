//
//  ViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 29/12/2022.
//

import UIKit
import SwipeCellKit




class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var ingridientsTableView: UITableView!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet var dishesFromIngridientsPopUpView: UIView!
    
    @IBOutlet weak var dishesFromIngridientsTableView: UITableView!
    
    // An instance of RandomManager that is responsible for fetching data from an API

    var randomManager = RandomManager()
    
    // Arrays that store data for table views
    var ingridients: [String] = [String]()
    var dishes : [RandomModel] = []
    var dishesFromIngridients: [DishFromIngridientsModel] = []
    
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
        
        // bounds
        blurEffect.bounds = self.view.bounds
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width *  0.9, height: self.view.bounds.height * 0.4)
        dishesFromIngridientsPopUpView.bounds = popUpView.bounds
        
        ingridientsTableView.dataSource = self
        ingridientsTableView.delegate = self
        ingridientsTableView.rowHeight = 80.0
        
        dishesFromIngridientsTableView.delegate = self
        dishesFromIngridientsTableView.dataSource = self
        
        addTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "Dish")
        tableView.rowHeight = 144
        
        randomManager.delegate = self
        
        randomManager.fetchDishes()
        
        logoutBackground.layer.cornerRadius = 15.0
        
        
    }
    
    
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        randomManager.fetchDishes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetails" {
            let detailsViewController = segue.destination as! DetailViewController
            let selectedCell = sender
            
            let indexPath = tableView.indexPath(for: selectedCell as! UITableViewCell)
            let row = indexPath!.row
            
            detailsViewController.recipeId = dishes[row].id
            detailsViewController.segueIdentifier = segue.identifier
            
        } else if segue.identifier == "goToDetailsFromDishesByIngridients"{
            let detailsViewController = segue.destination as! DetailViewController
            let selectedCell = sender
            
            let indexPath = dishesFromIngridientsTableView.indexPath(for: selectedCell as! UITableViewCell)
            let row = indexPath!.row
            
            detailsViewController.recipeId = dishesFromIngridients[row].id
            detailsViewController.segueIdentifier = segue.identifier
        }
        
        
    }

        
}
//MARK: tableView DataSource extension

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return dishes.count
        case self.ingridientsTableView:
            return ingridients.count
        case self.dishesFromIngridientsTableView:
            return dishesFromIngridients.count
        default:
            return 0
        }
        
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
        
        if tableView == self.tableView {
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
        } else if tableView == self.ingridientsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ingridient", for: indexPath) as! SwipeTableViewCell
            cell.delegate = self
            cell.textLabel?.text = ingridients[indexPath.row]
            
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.numberOfLines = 0
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishFromIngridient", for: indexPath)
            cell.textLabel?.text = dishesFromIngridients[indexPath.row].title
            
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        
        
        
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
            //            animateOut(desiredView: blurEffect)
            //            animateOut(desiredView: dishesFromIngridientsPopUpView)
        }
        
    }
    
}
//MARK: ApiCallDelegate Extension
extension HomeViewController : RandomManagerDelegate {
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]) {
        
        self.dishes.removeAll()
        
        DispatchQueue.main.async {
            for item in returned {
                self.dishes.append(item)
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didRecieveDishFromIngridients(_ randomManager: RandomManager, returned: [DishFromIngridientsModel]) {
        //managed to catch all the items in here, what to do with that
        
        for item in returned {
            self.dishesFromIngridients.append(item)
        }
        DispatchQueue.main.async {
            self.dishesFromIngridientsTableView.reloadData()
        }
        
    }
    
}
//MARK: - Ingridients PopUpWindow
extension HomeViewController {
    
    @IBAction func searchByIngridientsButtonPressed(_ sender: UIButton) {
        if ingridients.count != 0 {
            randomManager.fetchDishesFromIngridients(ingridients: ingridients)
            ingridients.removeAll()
            ingridientsTableView.reloadData()
            
            animateOut(desiredView: popUpView)
            animateIn(desiredView: dishesFromIngridientsPopUpView)
        }
        
        
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        ingridients.removeAll()
        ingridientsTableView.reloadData()
        animateIn(desiredView: blurEffect)
        animateIn(desiredView: popUpView)
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        animateOut(desiredView: popUpView)
        animateOut(desiredView: blurEffect)
        
    }
}
//MARK: - Animations
extension HomeViewController {
    
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view
        
        backgroundView!.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView!.center
        
        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
            
        }
    }
    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion:  { _ in
            desiredView.removeFromSuperview()}
        )
    }
    
}

//MARK: - dishesFromIngridientsPopUpView

extension HomeViewController {
    @IBAction func exitDishesPopUpViewButtonPressed(_ sender: UIButton) {
        animateOut(desiredView: dishesFromIngridientsPopUpView)
        animateOut(desiredView: blurEffect)
    }
}

//MARK: textField Delegate

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if addTextField.text != "" {
            ingridients.append(addTextField.text!)
        }
        
        ingridientsTableView.reloadData()
        
        addTextField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if addTextField.text != "" {
            return true
        } else {
            addTextField.placeholder = "Insert an ingridient here!"
            return false
        }
    }
}


//MARK: Swipe Cell Delegate
extension HomeViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.ingridients.remove(at: indexPath.row)
            //            self.ingridientsTableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}


