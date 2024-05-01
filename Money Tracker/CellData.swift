//
//  CellData.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 03/04/2024.
//

import Foundation

class cellData
{
    var amount: String
    var date: String
    var moneySpentOrRecievedImage: String
    var moneySpentOrRecievedBGImage: String
    var imageCategoryIcon: String
    
    init(amount: String, date: String, moneySpentOrRecievedImage: String, moneySpentOrRecievedBGImage: String, imageCategoryIcon: String) {
        self.amount = amount
        self.date = date
        self.moneySpentOrRecievedImage = moneySpentOrRecievedImage
        self.moneySpentOrRecievedBGImage = moneySpentOrRecievedBGImage
        self.imageCategoryIcon = imageCategoryIcon
    }

}
