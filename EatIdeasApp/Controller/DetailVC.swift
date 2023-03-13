//
//  DetailVC.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 12/03/2023.
//

import UIKit
import RealmSwift

#warning("pamiętaj o dodaniu jednostek do składników!")
class DetailVC: UIViewController {

    @IBOutlet weak var cookNowButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lactoseFreeIMV: UIImageView!
    @IBOutlet weak var glutenFreeIMV: UIImageView!
    @IBOutlet weak var veganIMV: UIImageView!
    @IBOutlet weak var vegetarianIMV: UIImageView!
    
    @IBOutlet weak var timeToCookLabel: UILabel!
    @IBOutlet weak var ingridientsLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    
    var recipeId : Int = 0
    
    let realm = try! Realm()
    
    var ingridients : [ExtendedIngredient] = []
    
    var displayedDishModel: DishRealmModel?
    
    #warning("for testing puropuse - should be nillable")
    var segueIdentifier: String = K.Segues.fromMainToDetails
    
    var imageData: Data = Data()
    
    var randomManager = RandomManager()
    //delegat dla protokołu randomProtocool
    // delegat dla tableview
    // rozpoczęcie działania aplikacji od metody determineSegueSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        randomManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpLayout()
        
        //check from which view we're coming
        determineSource(segue: segueIdentifier)
        
    }
    
    func determineSource(segue: String) {
        if segue == K.Segues.fromMainToDetails {
            //gather info from api
            randomManager.fetchSpecificDish(id: 716429)
        } else if segue == K.Segues.fromSavedToDetails {
            //ask database for the object
        }
    }
    
    fileprivate func setUpLayout() {
        let containerView = UIView(frame:  self.view.bounds)
        
        let backgroundImageView = UIImageView(frame:  containerView.bounds)
        
        backgroundImageView.image = UIImage(named: "mainImage")
        backgroundImageView.contentMode = .scaleToFill
        
        containerView.addSubview(backgroundImageView)
        
        let overlayView = UIView(frame: containerView.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.addSubview(overlayView)
        
        self.view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        
        cookNowButton.backgroundColor = UIColor(named: "pinkCellColor")
        cookNowButton.layer.cornerRadius = 15.0
        cookNowButton.setTitleColor(UIColor.white, for: .normal)
        
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 35
        tableView.separatorStyle = .none

    }
    
}
extension DetailVC: RandomManagerDelegate {
    func didFailWithError(error: Error) {
        print("error occured \(error)")
    }
    
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel) {
        
        displayedDishModel = DishRealmModel(model: returned)
        
        
        for item in returned.extendedIngredients {
            self.ingridients.append(item)
        }
        
        DispatchQueue.main.async {
            
            
            // TESTING PUROPUSE - SHOULD CHECK FOR VEGAN/GLUTENFREE ETC
//            if true {
//                self.lactoseFreeIMV.isHidden = true
//                self.glutenFreeIMV.isHidden = true
//                self.vegetarianIMV.isHidden = true
//                self.veganIMV.isHidden = true
//            }
            
            self.timeToCookLabel.text = "\(String(returned.readyInMinutes)) min"
            self.dishNameLabel.text = returned.title

           
            
            self.tableView.reloadData()
            
        }
        
    }
}
// TODO: tabela nie wyswietla danych - dane sa dobrze sciagane z api
extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingridient", for: indexPath)
        
        let dishName = ingridients[indexPath.row].name
        let ingridientUnit = ingridients[indexPath.row].measures.metric.unitShort
        let measuredValue = ingridients[indexPath.row].measures.metric.amount
        
        cell.textLabel?.text = "• \(dishName) \(measuredValue.rounded(toPlaces: 1)) \(ingridientUnit)"
        cell.textLabel?.textColor = UIColor.blue
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "SF Pro", size: 15.0)
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // nothing yet
    }
    
    
}
