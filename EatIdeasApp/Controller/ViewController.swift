//
//  ViewController.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 29/12/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var randomManager = RandomManager()
    
    
    //TODO: odwolanie sie do api w celu pozyskania kilku randomowych posilkow 
    var dishes : [RandomModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        randomManager.delegate = self
        
        
        randomManager.fetchDishes()
        
        
        // Do any additional setup after loading the view.
    }


}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    // stworz cell i zwroc ja
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath)
        print(indexPath.row)
        cell.textLabel?.text = dishes[indexPath.row].name
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}
//TODO: docelowo, po nacisnieciu danej pozycji nastepuje przejscie do innego okienka z wieksza liczba danych o wybranym produkcie
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ViewController : RandomManagerDelegate {
    func didRecieveDishes(_ randomManager: RandomManager, model: [RandomModel]) {
        
        DispatchQueue.main.async {
            for item in model {
                self.dishes.append(item)
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
  
}

