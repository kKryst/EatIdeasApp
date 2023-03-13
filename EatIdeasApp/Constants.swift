//
//  Constants.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 11/03/2023.
//

import Foundation


struct K {
    struct Segues {
        static let fromSavedToDetails = "goToDetailsFromSaved"
        static let fromMainToDetails = "goToDetails"
        
    }
}


extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
