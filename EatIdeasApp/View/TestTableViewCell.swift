//
//  DishTableViewCell.swift
//  splashScreenTest
//
//  Created by Krystian Konieczko on 27/02/2023.
//

import UIKit
import SkeletonView

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var textBackgroundView: UIView!
    @IBOutlet weak var greenImageBackground: UIView!
    @IBOutlet weak var whiteImageBackground: UIView!
    @IBOutlet weak var displayedImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius = CGFloat(26)
        
        textBackgroundView.layer.cornerRadius = cornerRadius
        greenImageBackground.layer.cornerRadius = cornerRadius
        whiteImageBackground.layer.cornerRadius = cornerRadius
        displayedImage.layer.cornerRadius = cornerRadius
        
        // set skeleton's corner radius for text
        label.linesCornerRadius = 7
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

