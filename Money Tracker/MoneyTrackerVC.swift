//
//  ViewController.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 29/03/2024.
//

import UIKit
import Foundation


class MoneyTrackerVC: UIViewController {
    
//  table view variable
    @IBOutlet var tableView: UITableView!
    
//  class used to store data about cells
    var transactionList = [cellData]()
    
//  current balance variable
    @IBOutlet var labelCurrentBalance: UILabel!
//  variable to store the current balance number
    var currentbalanceNumber = 0
    
//  UITableView Backgroung Image
    @IBOutlet var imageStackViewBG: UIImageView!

//  money spent or recieved buttons background Image
    @IBOutlet var imageMoneyAddAndSpentBG: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      to keep the app appearance light mode
        overrideUserInterfaceStyle = .light
        
//      function that contains all the configuration
        configureMoneyTrackerVC()
    }
    
//    a function containing all element code
    func configureMoneyTrackerVC() {
        
//      to keep the app appearance light mode
        overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
        
//      applying border radius function
        applyBorderRadius()
        
//      initially current balance label displays 0
        labelCurrentBalance.text = "0 Rs"
        
        
//      setting background image for the UITableView
        let backgroundImage = UIImage(named: "Transaction History BG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        tableView.layer.cornerRadius = 46
    }
    
    
//  border radius function for the money spent or money added button background image
    func applyBorderRadius() {
        imageStackViewBG.layer.cornerRadius = 55
        imageMoneyAddAndSpentBG.layer.cornerRadius = 30
        labelCurrentBalance?.layer.cornerRadius = 8
        labelCurrentBalance?.layer.masksToBounds = true
        
    }
    
    
//  function to get currten date
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
    
    
//  adding the transaction data to the transactionList
    func addTransaction(_ transaction: cellData) {
        transactionList.insert(transaction, at: 0)
    }
    
    
//  alert view implementation
    func buttonTapped(message: String, title: String, buttonName: String) {
        let ac = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
//      adding a text field
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Amount"
            textField.keyboardType = .numberPad // getting the num pad up
        }
        
//      setting color of alert view controller
        
//      adding submit button functionality
        let SubmitAction = UIAlertAction(title: "\(title)",
                                         style: .default) { [unowned self, ac] action in
//          This is the text entry after enter key
            let AddedItem = ac.textFields![0]
            
//          using a function to add items to the uitable view and append data to transaction list and to
//          sned data to currentBalance label
            addMoneyOrSpentMoneyImplementation(AddedItem.text!, buttonName: buttonName)
        }
        
//      condition for Add and Spent button color
        if title == "Add" {
            SubmitAction.setValue(UIColor(hex: "#008000"), forKey: "titleTextColor")
        } else {
            SubmitAction.setValue(UIColor(hex: "#FF474D"), forKey: "titleTextColor")
        }
//      creating a cancel button
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .default)
        
//      setting cancel button color
        cancelButton.setValue(UIColor(hex: "#FF6C71"), forKey: "titleTextColor")
        
//      adding the button
        ac.addAction(SubmitAction)
        ac.addAction(cancelButton)
        present(ac, animated: true)
    }
    
    
    func addMoneyOrSpentMoneyImplementation(_ item: String, buttonName: String) {
//      Using this to Format the number and add commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let numberEntered = Int(item)
//      the formatted number
        let numberFormatted = numberFormatter.string(from: NSNumber(value: numberEntered ?? 0))
        
        //      if the number entered is 0 or nothing it returns without appending it to transactionlist
        if numberEntered == 0 || numberEntered == nil {
            return
        }
             
//        let dateManager = DateManager()
        // current date store in this variable
        let currentDate = getCurrentDate()
        
        let lastIndex = transactionList.count
        
        var transOne: cellData
        
//      add the cell data and displaying it according to the button name given
        if buttonName == "addMoney" {
            transOne = cellData(amount: "+ \(numberFormatted!) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-recieve", moneySpentOrRecievedBGImage: "Green Gradient")
            currentbalanceNumber += numberEntered ?? 0
            let currentBalanceFormattedNumber = numberFormatter.string(from: NSNumber(value: currentbalanceNumber))
            labelCurrentBalance.text = "\(currentBalanceFormattedNumber!) Rs"
        } else {
            transOne = cellData(amount: "- \(numberFormatted!) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-send", moneySpentOrRecievedBGImage: "Red Gradient")
            currentbalanceNumber -= numberEntered ?? 0
            let currentBalanceFormattedNumber = numberFormatter.string(from: NSNumber(value: currentbalanceNumber))
            labelCurrentBalance.text = "\(currentBalanceFormattedNumber!) Rs"
        }
        
        addTransaction(transOne)
        
        // adding new row at top such that latest result remains on top
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        return
    }
    
}


extension MoneyTrackerVC: UITableViewDataSource, UITableViewDelegate {
    
//  setting number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
//  setting cell height through this function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
//  number of sections in UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      selecting the cell with the identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackerCell
//      setting data of cell to display
        cell.labelAmountData.text = "\(transactionList[indexPath.row].amount)"
        cell.labelDateData.text = "\(transactionList[indexPath.row].date)"
        cell.imageTransactionStatus.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedImage)
        cell.imageTransactionStatusBG.image = UIImage(named: transactionList[indexPath.row].moneySpentOrRecievedBGImage)
        
//      setting background color to transparent such that there remains a space between two cells
        cell.layer.backgroundColor = UIColor.clear.cgColor
//      setting background imgage radius of the cell such that uniformity is obtained and it looks like a cell
        cell.imageTransactionStatusBG.layer.cornerRadius = 15
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        transactionList.remove(at: indexPath.row)
//        
//        let indexPaths = [indexPath]
//        tableView.deleteRows(at: indexPaths, with: .automatic)
//    }

}

extension MoneyTrackerVC {
    
//  add money button
    @IBAction func addMoney(_ sender: Any) {
//      function to check which button is tapped
        buttonTapped(message: "Add Money", title: "Add", buttonName: "addMoney")
    }
    
//  money spent button
    @IBAction func spentMoney(_ sender: Any) {
//      function to check which button is tapped
        buttonTapped(message: "Money Spent", title: "Spent", buttonName: "spentMoney")
    }
}