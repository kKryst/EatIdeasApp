//
//  DetailVC.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 12/03/2023.
//

import UIKit
import RealmSwift
import SkeletonView

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
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var recipeButton: UIButton!
    
    @IBOutlet weak var additionalInfoStackView: UIStackView!
    
    //recipeView IBOutlets
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var ingridientsView: UIView!
    
    @IBOutlet weak var recipeDescriptionLabel: UILabel!
    @IBOutlet weak var listIngridientsLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var goLeftButton: UIButton!
    @IBOutlet weak var goRightButton: UIButton!
    
    var recipeId : Int = 0
    
    let realm = try! Realm()
    
    var ingridients : [ExtendedIngredient] = []
    
    var displayedDishModel: DishRealmModel?
    
//#warning("for testing puropuse - should be nillable")
    var segueIdentifier: String = K.Segues.fromMainToDetails
    
    var imageData: Data = Data()
    
    var randomManager = RandomManager()
    
    var backgroundImageView = UIImageView()
    
    var stepCounter = 1
    
    var recipeDescriptions : [RecipeInstructionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpLayout()
        
        //check from which view we're coming
        determineSource(segue: segueIdentifier)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != recipeView && touch?.view != ingridientsView{
            hideRecipe()
        }
    }
    
    func determineSource(segue: String) {
        if segue == K.Segues.fromMainToDetails {
            randomManager.fetchSpecificDish(id: recipeId)
        } else if segue == K.Segues.fromSavedToDetails {
            //ask database for the object
            displayedDishModel = DatabaseManager.shared.fetchObject(id: recipeId)
            
            // append items to ingridients tableView
            setUpData()
            
        }
    }
    
    func setUpData(){
        
        //set up data for the description
        randomManager.fetchRecipe(id: recipeId)
        
        //safe casting the object
        if let dish = displayedDishModel{
            
            // fill table with ingridients
            for item in dish.extendedIngridients {
                self.ingridients.append(ExtendedIngredient(databaseIngridient: item))
            }
            // interface changes
            DispatchQueue.main.async {
                
                if dish.vegan == "yes" {
                    self.veganIMV.isHidden = false
                }
                if dish.vegetarian == "yes"{
                    self.vegetarianIMV.isHidden = false
                }
                if dish.glutenFree == "yes"{
                    self.glutenFreeIMV.isHidden = false
                }
                if dish.diaryFree == "yes"{
                    self.lactoseFreeIMV.isHidden = false
                }
                
                self.timeToCookLabel.text = "\(String(dish.readyInMinutes)) min"
                self.dishNameLabel.text = dish.title
                
                //hide all Skeleton Views
                self.tableView.hideSkeleton()
                //saving the label in a variable to place it later on in the label due to framework's bug which clears up the label's text
                var timeToCookLabelTextValue : String = ""
                var dishNameLabelTextValue : String = ""
                if let safelabelTextValue = self.timeToCookLabel.text {
                    timeToCookLabelTextValue = safelabelTextValue
                }
                
                if let safeDishNameLabelTextValue = self.dishNameLabel.text {
                    dishNameLabelTextValue = safeDishNameLabelTextValue
                }
                
                self.timeToCookLabel.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.dishNameLabel.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.timeToCookLabel.text = timeToCookLabelTextValue
                self.dishNameLabel.text = dishNameLabelTextValue
                //reload data in tableView
                self.tableView.reloadData()
                
                       
            }
        }
    }
    
    fileprivate func setUpLayout() {
        
        // create a container view
        let containerView = UIView(frame:  self.view.bounds)
        // set up background's image size
        backgroundImageView = UIImageView(frame:  containerView.bounds)
        backgroundImageView.contentMode = .scaleToFill
        // add container view to the main view
        containerView.addSubview(backgroundImageView)
        // create and present overlay view which makes background image darker
        let overlayView = UIView(frame: containerView.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.addSubview(overlayView)
        
        self.view.addSubview(containerView)
        // send the view to the back so it doesnt cover up other parts of the view
        view.sendSubviewToBack(containerView)
        
        // cook button's design
        cookNowButton.backgroundColor = UIColor(named: "pinkCellColor")
        cookNowButton.layer.cornerRadius = 15.0
        cookNowButton.setTitleColor(UIColor.white, for: .normal)
        
        // tableview design
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 35
        tableView.separatorStyle = .none
        
        // hide alergies info
        lactoseFreeIMV.isHidden = true
        glutenFreeIMV.isHidden = true
        vegetarianIMV.isHidden = true
        veganIMV.isHidden = true
        
        // hide recipe view
        recipeView.isHidden = true
        ingridientsView.isHidden = true
        
        // change back button's color
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        // set background image
        backgroundImageView.image = UIImage(named: "recipeBackground")
        
        // set favourite button's image
        if DatabaseManager.shared.isObjectSaved(id: recipeId) {
            favouriteButton.setBackgroundImage(UIImage(named: "favouriteColored"), for: .normal)
        }
        
        //recipeView design
        recipeView.layer.cornerRadius = 15.0
        ingridientsView.layer.cornerRadius = 15
        ingridientsView.backgroundColor = UIColor.clear
        ingridientsView.layer.borderWidth = 2
        ingridientsView.layer.borderColor = UIColor.white.cgColor
        
        setUpAndPresentSkeletonViews()

        
    }
    
    func getImageFromURL(_ url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image from URL: \(error.localizedDescription)")
            return nil
        }
    }
    // helper function to display skeletonView
    func setUpAndPresentSkeletonViews() {
        
        timeToCookLabel.isSkeletonable = true
        tableView.isSkeletonable = true
        dishNameLabel.isSkeletonable = true
        
        dishNameLabel.linesCornerRadius = 5
        dishNameLabel.showSkeleton(usingColor: .silver, transition: .crossDissolve(0.25))
        
        
        timeToCookLabel.linesCornerRadius = 5
        timeToCookLabel.skeletonTextNumberOfLines = 2
        timeToCookLabel.showSkeleton(usingColor: .silver, transition: .crossDissolve(0.25))
        
        tableView.skeletonCornerRadius = 15.0
        tableView.showSkeleton(usingColor: .silver, transition: .crossDissolve(0.25))
        
        
    }
    
    @IBAction func addToFavouritesButtonPressed(_ sender: UIButton) {
        // check for object in DB
        if DatabaseManager.shared.isObjectSaved(id: recipeId) {
            //delete the object
            DatabaseManager.shared.deleteFromDatabase(id: recipeId)
            DispatchQueue.main.async {
                // change button's icon
                self.favouriteButton.setBackgroundImage(UIImage(named: "favourite"), for: .normal)
            }
        } else {
            // create the object in DB
            DatabaseManager.shared.createInDatabase(dish: displayedDishModel!)
            DispatchQueue.main.async {
                //change button's icon
                self.favouriteButton.setBackgroundImage(UIImage(named: "favouriteColored"), for: .normal)
            }
            
        }
        
    }
    

    
    
    
    
}

extension DetailVC: RandomManagerDelegate {
    
    func didFailWithError(error: Error) {
        print("error occured \(error)")
    }
    
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel) {
        
        displayedDishModel = DishRealmModel(model: returned)
        
        //set up data
        setUpData()
        
    }
    
    func didRecieveRecipe(_ randomManager: RandomManager, returned: [RecipeInstructionModel]) {
        for item in returned {
            recipeDescriptions.append(item)
        }
        presentDescription()
    }
    
}

extension DetailVC: UITableViewDelegate, SkeletonTableViewDataSource {
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
        // nothing here to be done
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Ingridient"
    }
    
}

//MARK: -- RecipeView logic
extension DetailVC {
    
    @IBAction func recipeButtonPressed(_ sender: UIButton) {
        
        presentRecipe()
    }
    
    func presentRecipe(){
        //hide unnecessary objects
        tableView.isHidden = true
        additionalInfoStackView.isHidden = true
        favouriteButton.isHidden = true
        recipeButton.isHidden = true
        
        // show recipeView on the screen
        recipeView.isHidden = false
    }
    
    func hideRecipe(){
        //hide unnecessary objects
        tableView.isHidden = false
        additionalInfoStackView.isHidden = false
        favouriteButton.isHidden = false
        recipeButton.isHidden = false
        
        
        // show recipeView on the screen
        recipeView.isHidden = true
        
    }
    
    func presentDescription() {
        // build a coma-separated list of ingridients as one string
        var listOfIngridientsAsString = ""
        for item in self.recipeDescriptions[self.stepCounter - 1].ingridients {
            listOfIngridientsAsString.append("\(item), ")
        }
        if listOfIngridientsAsString.last == " " || listOfIngridientsAsString == "," {
            listOfIngridientsAsString.removeLast()
            listOfIngridientsAsString.removeLast()
        }
        
        
        if stepCounter == 1 {
            DispatchQueue.main.async {
                self.goLeftButton.isHidden = true
            }
            

        } else if stepCounter == recipeDescriptions.count{
            DispatchQueue.main.async {
                self.goRightButton.isHidden = true
            }
        
            
        } else {
            DispatchQueue.main.async {
                self.goRightButton.isHidden = false
                self.goLeftButton.isHidden = false
            }
        }
        DispatchQueue.main.async {
            self.recipeDescriptionLabel.text = self.recipeDescriptions[self.stepCounter - 1].description
            self.listIngridientsLabel.text = listOfIngridientsAsString
            self.stepLabel.text = "Step \(self.stepCounter)"
            
        }
        
        
    }
    
    @IBAction func showIngridientsButtonPressed(_ sender: UIButton) {
        // show if hidden, hide if shown
        ingridientsView.isHidden = !ingridientsView.isHidden
        
    }
    
    @IBAction func goRightButtonPressed(_ sender: UIButton) {
        stepCounter += 1
        presentDescription()
    }
    
    @IBAction func goLeftButtonPressed(_ sender: UIButton) {
        stepCounter -= 1
        presentDescription()
    }
    
}



