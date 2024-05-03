//
//  CellData.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 03/04/2024.
//

import Foundation

class cellData: NSObject, Codable
{
    var amount: String
    var date: String
    var imageMoneySpentOrRecieved: String
    var imageMoneySpentOrRecievedBG: String
    var imageCategoryIcon: String
    
    init(amount: String, date: String, moneySpentOrRecievedImage: String, moneySpentOrRecievedBGImage: String, imageCategoryIcon: String) {
        self.amount = amount
        self.date = date
        self.imageMoneySpentOrRecieved = moneySpentOrRecievedImage
        self.imageMoneySpentOrRecievedBG = moneySpentOrRecievedBGImage
        self.imageCategoryIcon = imageCategoryIcon
    }

}
