//
//  ViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 29/12/2022.
//

import UIKit
import SwipeCellKit



class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var ingridientsTableView: UITableView!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet var dishesFromIngridientsPopUpView: UIView!
    
    @IBOutlet weak var dishesFromIngridientsTableView: UITableView!
    
    var randomManager = RandomManager()
    
    var ingridients: [String] = [String]()
    
    var dishes : [RandomModel] = []
    
    var dishesFromIngridients: [DishFromIngridientsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        randomManager.delegate = self
        
        randomManager.fetchDishes()
        
        
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
    

    //TODO: all works fine, next step is to add an option to allow users to delete ingridients if they want to
    
    
    
}
//MARK: tableView DataSource extension
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return dishes.count
        } else if tableView == self.ingridientsTableView{
            return ingridients.count
        } else {
            return dishesFromIngridients.count
        }
        
    }
    // stworz cell i zwroc ja
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath)
            cell.textLabel?.text = dishes[indexPath.row].name
            
            //zawijanie wierszy w komorce
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.numberOfLines = 0
            return cell
        } else if tableView == self.ingridientsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ingridient", for: indexPath) as! SwipeTableViewCell
            cell.delegate = self
            cell.textLabel?.text = ingridients[indexPath.row]
            
            //zawijanie wierszy w komorce
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
extension ViewController : UITableViewDelegate {
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
extension ViewController : RandomManagerDelegate {
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
extension ViewController {
    
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
extension ViewController {
    
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

extension ViewController {
    @IBAction func exitDishesPopUpViewButtonPressed(_ sender: UIButton) {
        animateOut(desiredView: dishesFromIngridientsPopUpView)
        animateOut(desiredView: blurEffect)
    }
}

//MARK: textField Delegate

extension ViewController: UITextFieldDelegate {
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
extension ViewController: SwipeTableViewCellDelegate {
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


