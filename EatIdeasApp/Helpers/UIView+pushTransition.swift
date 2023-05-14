//
//  UIView+pushTransition.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 14/05/2023.
//

import UIKit

extension UIView {
    func pushTransition(_ duration: CFTimeInterval, direction: CATransitionSubtype) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = direction
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
