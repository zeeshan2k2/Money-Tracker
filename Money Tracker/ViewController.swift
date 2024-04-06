//
//  ViewController.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 29/03/2024.
//

import UIKit

var arr1 = [3, 4, 3, 3]

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var transactionList = [cellData]()
    
    @IBOutlet var currentBalance: UILabel!
    
    @IBOutlet var StackViewBGImage: UIImageView!

    @IBOutlet var moneyAddAndSpentBGImage: UIImageView!

    var moneySpentOrAddedArray: [String] = []

    var dateOfTransactionArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        applyBorderRadius()
        
////       to reverse cell addition in TableView
//        tableView.transform  = CGAffineTransform(scaleX: 1, y: -1)
        
        let backgroundImage = UIImage(named: "Transaction History BG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        tableView.layer.cornerRadius = 48
        
    }
    
    
    
    func addTransaction(_ transaction: cellData) {
            transactionList.append(transaction)
    }
    
    @IBAction func addMoney(_ sender: Any) {
        let lastIndex = transactionList.count
        let transOne = cellData(amount: "+ \(Int.random(in: 1...100)) Rs", date: "22-12-2024", moneySpentOrRecievedImage: "money-recieve", moneySpentOrRecievedBGImage: "Green Gradient")
        addTransaction(transOne)
        
        // Check if new transaction is added
        
        
        let indexPath = IndexPath(row: lastIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        

    }
    
    @IBAction func spentMoney(_ sender: Any) {
        let lastIndex = transactionList.count
        let transOne = cellData(amount: "+ \(Int.random(in: 1...100)) Rs", date: "22-12-2024", moneySpentOrRecievedImage: "money-send", moneySpentOrRecievedBGImage: "Red Gradient")
        addTransaction(transOne)
        
        let indexPath = IndexPath(row: lastIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    

    
    func applyBorderRadius() {
        StackViewBGImage.layer.cornerRadius = 55
        moneyAddAndSpentBGImage.layer.cornerRadius = 30
        currentBalance?.layer.cornerRadius = 8
        currentBalance?.layer.masksToBounds = true
        
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
        print(moneySpentOrAddedArray, dateOfTransactionArray)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.amountData.text = "\(transactionList[indexPath.row].amount)"
        cell.dateData.text = "\(transactionList[indexPath.row].date)"
        cell.transactionStatusImage.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedImage)
        cell.transactionStatusBGImage.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedBGImage)
////      to add the cell at the top from bottom up
//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        print("this is number of rows \(transactionList.count)")
        return cell
    }

}
