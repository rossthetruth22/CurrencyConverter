//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/20/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var flag: UIImageView?
    @IBOutlet weak var mainName: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var currencyCode: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
