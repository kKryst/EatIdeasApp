//
//  UILabel+HideSkeletonView.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 27/04/2023.
//

import Foundation
import UIKit

extension UILabel {
    func hideSkeletonFixed(label: UILabel) {
        let textToPersist = label.text!
        label.hideSkeleton()
        label.text! = textToPersist
    }
    
}
