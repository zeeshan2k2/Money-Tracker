//
//  ViewController.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 29/03/2024.
//

import UIKit
import Foundation

var arr1 = [3, 4, 3, 3]


// Class for Date
class DateManager {
    
    func getCurrentDate() -> String {
        // Get the current date
        let currentDate = Date()

        // Create a calendar object
        let calendar = Calendar.current

        // Get the components of the current date
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)

        // Extract the day, month, and year from the components
        let day = components.day
        let month = components.month
        let year = components.year

        // Return the current date as a formatted string
        return "\(day!)-\(month!)-\(year!)"
    }
}


//let dateManager = DateManager()
//// current date store in this variable
//let currentDate = dateManager.getCurrentDate()



class ViewController: UIViewController {
    
//  table view variable
    @IBOutlet var tableView: UITableView!
    
//  class used to store data about cells
    var transactionList = [cellData]()
    
//  current balance variable
    @IBOutlet var currentBalance: UILabel!
//  variable to store the current balance number
    var currentbalanceNumber = 0
    
//  UITableView Backgroung Image
    @IBOutlet var StackViewBGImage: UIImageView!

//  money spent or recieved buttons background Image
    @IBOutlet var moneyAddAndSpentBGImage: UIImageView!

    
//    array to store date and amount if needed
    
//    var moneySpentOrAddedArray: [String] = []
//    var dateOfTransactionArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      to keep the app appearance light mode
        overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
        
//      applying border radius function
        applyBorderRadius()
        
//      initially current balance label displays 0
        currentBalance.text = "0 Rs"
        
////       to reverse cell addition in TableView
//        tableView.transform  = CGAffineTransform(scaleX: 1, y: -1)
        
        
//      setting background image for the UITableView
        let backgroundImage = UIImage(named: "Transaction History BG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        tableView.layer.cornerRadius = 46
        
    }
    
    
//  adding the transaction data to the transactionList
    func addTransaction(_ transaction: cellData) {
            transactionList.append(transaction)
    }
    
    
    func buttonTapped(message: String, title: String, buttonName: String) {
        let ac = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
//      adding a text field
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Amount"
            textField.keyboardType = .numberPad // getting the num pad up
        }
        
//      adding submit button functionality
        let SubmitAction = UIAlertAction(title: "\(title)",
                                         style: .default) { [unowned self, ac] action in
//          This is the text entry after enter key
            let AddedItem = ac.textFields![0]
            
//          using a function to add items in the uitable view
            addMoneyOrSpentMoney(AddedItem.text!, buttonName: buttonName)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .default)
        
//      adding the button
        ac.addAction(SubmitAction)
        ac.addAction(cancelButton)
        present(ac, animated: true)
    }
    
    
    func addMoneyOrSpentMoney(_ item: String, buttonName: String) {
        let numberEntered = Int(item)
        
        
        if buttonName == "addMoney" {
            
            //      if the number entered is 0 or nothing it returns without appending it to transactionlist
            if numberEntered == 0 || numberEntered == nil {
                return
            }
            
            currentbalanceNumber += numberEntered ?? 0
            currentBalance.text = "\(currentbalanceNumber) Rs"
            
            let dateManager = DateManager()
            // current date store in this variable
            let currentDate = dateManager.getCurrentDate()
            
            let lastIndex = transactionList.count
            let transOne = cellData(amount: "+ \(item) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-recieve", moneySpentOrRecievedBGImage: "Green Gradient")
            addTransaction(transOne)
            
            // Check if new transaction is added
            
            let indexPath = IndexPath(row: lastIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            return
            
        } else if buttonName == "spentMoney"{
            //      if the number entered is 0 or nothing it returns without appending it to transactionlist
            if numberEntered == 0 || numberEntered == nil {
                return
            }
            
            currentbalanceNumber -= numberEntered ?? 0
            currentBalance.text = "\(currentbalanceNumber) Rs"
            
            let dateManager = DateManager()
            // current date store in this variable
            let currentDate = dateManager.getCurrentDate()
            
            let lastIndex = transactionList.count
            let transOne = cellData(amount: "- \(item) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-send", moneySpentOrRecievedBGImage: "Red Gradient")
            addTransaction(transOne)
            
            // Check if new transaction is added
            
            let indexPath = IndexPath(row: lastIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            return
        }
    }
    
//  add money button
    @IBAction func addMoney(_ sender: Any) {
        
        buttonTapped(message: "Add Money", title: "Add", buttonName: "addMoney")
        
  
    }
    
//  money spent button
    @IBAction func spentMoney(_ sender: Any) {
        
        buttonTapped(message: "Money Spent", title: "Spent", buttonName: "spentMoney")
        
    }
    

//  border radius function for the money spent or money added button background image
    func applyBorderRadius() {
        StackViewBGImage.layer.cornerRadius = 55
        moneyAddAndSpentBGImage.layer.cornerRadius = 30
        currentBalance?.layer.cornerRadius = 8
        currentBalance?.layer.masksToBounds = true
        
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
    
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
//      selecting the cell with the identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        
//      setting data of cell to display
        cell.amountData.text = "\(transactionList[indexPath.row].amount)"
        cell.dateData.text = "\(transactionList[indexPath.row].date)"
        cell.transactionStatusImage.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedImage)
        cell.transactionStatusBGImage.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedBGImage)
        
////      to add the cell at the top from bottom up
//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
}
