//
//  RandomManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 01/01/2023.
//

import Foundation



protocol RandomManagerDelegate {
    func didFailWithError(error: Error)
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel)
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel])
    func didRecieveDishFromIngridients(_ randomManager: RandomManager, returned: [DishFromIngridientsModel])
}

extension RandomManagerDelegate {
    func didRecieveSpecificDish(_ randomManager: RandomManager, returned: DishModel){}
    func didRecieveDishes(_ randomManager: RandomManager, returned: [RandomModel]){}
    func didRecieveDishFromIngridients(_ randomManager: RandomManager, returned: [DishFromIngridientsModel]){}
    
    
}

struct RandomManager{
    // sciezka do api
    let dishApi = "https://api.spoonacular.com/recipes/random?apiKey=1b03f0f7b52f417597ff56a137c661cb&number=6"
    
    var delegate: RandomManagerDelegate?
    
    
    
    func fetchDishes() {
        performRequest(with: dishApi)
    }
    
    func fetchSpecificDish(id: Int){
        //https://api.spoonacular.com/recipes/\(id)/information?apiKey=1b03f0f7b52f417597ff56a137c661cb
        performRequestForSpecificDish(with: "https://api.spoonacular.com/recipes/\(id)/information?apiKey=1b03f0f7b52f417597ff56a137c661cb")
        
    }
    func fetchDishesFromIngridients(ingridients: [String]){
        var ingridientsAsString: String = ""
        for item in ingridients {
            ingridientsAsString.append("\(item),+")
        }
        ingridientsAsString.removeLast()
        ingridientsAsString.removeLast()
        
        let urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingridientsAsString)&number=10&apiKey=1b03f0f7b52f417597ff56a137c661cb&ranking=2"
        
        performRequestWithIngridients(with: urlString)
    }
    
    
    func performRequest (with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                // jeżeli wystąpił błąd - przerwij działanie funkcji
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let response = self.parseJSON(safeData){
                        self.delegate?.didRecieveDishes(self, returned: response)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performRequestForSpecificDish (with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                // jeżeli wystąpił błąd - przerwij działanie funkcji
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let response = self.parseJSONForSpecificDish(safeData){
                        self.delegate?.didRecieveSpecificDish(self, returned: response)
                    }
                }
            }
            task.resume()
        }
    }
    func performRequestWithIngridients(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                // jeżeli wystąpił błąd - przerwij działanie funkcji
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let response = self.parseJSONForDishFromIngridients(safeData){
                        self.delegate?.didRecieveDishFromIngridients(self, returned: response)
                    }
                }
            }
            task.resume()
        }
        
    }
    // funkcja odpowiadająca za przetworzenie JSONA otrzymanego z serwera na obiekt swift.class
    func parseJSON(_ randomData: Data) -> [RandomModel]?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RandomData.self, from: randomData)
            
            var recipesModels : [RandomModel] = [RandomModel]()
            
            for item in decodedData.recipes{
                recipesModels.append(RandomModel(id: item.id, name: item.title))
            }
            // tworzenie struktury przesyłając jej dane
             return recipesModels
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    // json moglby zwracac bardziej ogolny obiekt, randomData moglby byc duzo bardziej ogolnym typem danych
    func parseJSONForSpecificDish(_ dishData: Data) -> DishModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(DishData.self, from: dishData)
            
            return DishModel(
                id: decodedData.id,
                title: decodedData.title,
                image: decodedData.image,
                readyInMinutes: decodedData.readyInMinutes,
                diaryFree: decodedData.dairyFree,
                glutenFree: decodedData.glutenFree,
                vegan: decodedData.vegan,
                vegetarian: decodedData.vegetarian,
                extendedIngredients: decodedData.extendedIngredients)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONForDishFromIngridients(_ dishFromIngridientsData: Data) -> [DishFromIngridientsModel]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([DishFromIngridientsData].self, from: dishFromIngridientsData)
            
            var dishesFromIngridients: [DishFromIngridientsModel] = [DishFromIngridientsModel]()
            
            for item in decodedData {
                dishesFromIngridients.append(DishFromIngridientsModel(id: item.id, image: item.image, missedIngridients: item.missedIngredients, title: item.title, unusedIngridients: item.unusedIngredients, usedIngridients: item.usedIngredients))
            }
            
            return dishesFromIngridients
            // zwróć listę zwróconych posiłków
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
