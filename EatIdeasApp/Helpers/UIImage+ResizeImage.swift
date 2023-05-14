//
//  UIImage+ResizeImage.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 27/04/2023.
//

import Foundation
import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
