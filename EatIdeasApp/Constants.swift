//
//  Constants.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 11/03/2023.
//

import Foundation
import UIKit


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

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


extension UILabel {
    func hideSkeletonFixed(label: UILabel) {
        let textToPersist = label.text!
        label.hideSkeleton()
        label.text! = textToPersist
    }
    
}
