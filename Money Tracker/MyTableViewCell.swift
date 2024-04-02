//
//  MyTableViewCell.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 03/04/2024.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet var amountData: UILabel!
    
    
    @IBOutlet var dateData: UILabel!
    
    
    @IBOutlet var transactionStatusImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
