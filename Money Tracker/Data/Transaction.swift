//
//  CellData.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 03/04/2024.
//

import Foundation

struct Transaction {
    let id: UUID
    let amount: Double
    let date: Date
    let type: TransactionType
    let category: String
}

enum TransactionType {
    case income
    case expense
}
