//
//  ViewController.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 29/03/2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        applyBorderRadius()
        
        let backgroundImage = UIImage(named: "Transaction History BG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        tableView.layer.cornerRadius = 48
        
        
//        let transOne = cellData(amount: "+ 345 Rs", date: "22-12-2024", moneySpentOrRecievedImage: "money-send")
//        transactionList.append(cellData(amount: "+ 345 Rs", date: "22-12-2024", moneySpentOrRecievedImage: "money-send"))

    }
    
    
    var transactionList = [cellData]()
    
    
    @IBAction func addMoney(_ sender: Any) {
        print("add money")
        transactionList.append(cellData(amount: "+ 345 Rs", date: "22-12-2024", moneySpentOrRecievedImage: "money-send"))
        tableView.reloadData()
    }
    
    @IBAction func spentMoney(_ sender: Any) {
        print("spent money")
    }
    

    
    @IBOutlet var currentBalance: UILabel!
    
    @IBOutlet var StackViewBGImage: UIImageView!

    @IBOutlet var moneyAddAndSpentBGImage: UIImageView!
    
    

    var moneySpentOrAddedArray: [String] = []

 
    var dateOfTransactionArray: [String] = []
    
    func applyBorderRadius() {
        StackViewBGImage.layer.cornerRadius = 55
        moneyAddAndSpentBGImage.layer.cornerRadius = 30
        currentBalance?.layer.cornerRadius = 8
        currentBalance?.layer.masksToBounds = true
        
    }
    
    @IBOutlet var tableView: UITableView!
        
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
        print(moneySpentOrAddedArray, dateOfTransactionArray)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.amountData.text = "\(transactionList[indexPath.row].amount)"
        cell.dateData.text = "\(transactionList[indexPath.row].date)"
        cell.transactionStatusImage.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedImage)
        return cell
    }
    
}

