//
//  Double+Rounding.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 27/04/2023.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
