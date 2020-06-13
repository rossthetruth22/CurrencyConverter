//
//  flagImage.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 6/11/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class flagImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
    }
}
