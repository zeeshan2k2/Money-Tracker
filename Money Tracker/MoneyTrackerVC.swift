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
    
//  category
    var selectedCategoryForMoneySpent: String?
    
//  category
    var selectedCategoryForMoneyAdded: String?
    
    
//  setting array for spent money category and add money category
    let categoriesSpentMoney =  ["Food", "Groceries", "Travelling", "Vehicle", "Education", "Household", "Socialising", "Clothes", "Mobile", "Other"]
    let categoriesAddMoney = ["Allowance", "Salary", "Petty cash", "Bonus", "Other"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      function that contains all the configuration
        configureMoneyTrackerVC()
    }
    
//    a function containing all element code
    func configureMoneyTrackerVC() {
        
//      to keep the app appearance light mode
        overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
        
//      applying border radius
        imageStackViewBG.layer.cornerRadius = 55
        imageMoneyAddAndSpentBG.layer.cornerRadius = 30
        labelCurrentBalance?.layer.cornerRadius = 8
        labelCurrentBalance?.layer.masksToBounds = true
        
//      initially current balance label displays 0
        labelCurrentBalance.text = "0 Rs"
        
//      setting background image for the UITableView
        let backgroundImage = UIImage(named: "Transaction History BG")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
        tableView.layer.cornerRadius = 46
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
    
//  will be use to convet number into decimal with commas
    func numberFormat(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let numberEntered = number
        //      the formatted number
        let numberFormatted = numberFormatter.string(from: NSNumber(value: numberEntered)) ?? " "
        
        return numberFormatted
    }
    
    
//  adding the transaction data to the transactionList
    func addTransaction(_ transaction: cellData) {
        transactionList.insert(transaction, at: 0)
    }
    
//  function which contains all the categories
    func categories(ac: UIAlertController, categoryType categories: [String], isEditButton: Bool) {
        
//      placeholder text set to Category by default
        var placeHolderText = "Category"
        
//      if edit button is clicked either it'll show "Other" as placeholder or selected category name
        if isEditButton == true {
            if categories.count > 5{
                placeHolderText = "\(self.selectedCategoryForMoneySpent ?? "Other")"
            } else {
                placeHolderText = "\(self.selectedCategoryForMoneyAdded ?? "Other")"
            }
        }
        
        
//        if isEditButton != true {
        ac.addTextField(configurationHandler: { textField in
            textField.placeholder = "\(placeHolderText)"
            let button = UIButton(type: .custom)
            button.setTitle("Select", for: .normal)
            
            // Create a menu with categories
            let categoriesMenu = UIMenu(title: "Categories", children: categories.map { category in
                UIAction(title: category) { action in
                    if categories.count > 5 {
                        self.selectedCategoryForMoneySpent = category
                        textField.text = category
                    } else {
                        self.selectedCategoryForMoneyAdded = category
                        textField.text = category
                    }
                }
            })
            
            button.menu = categoriesMenu
            button.showsMenuAsPrimaryAction = true
            textField.rightView = UIImageView(image: UIImage(systemName: "chevron.down"))
            textField.rightView?.tintColor = .black
            textField.rightViewMode = .always
            textField.isUserInteractionEnabled = false
            textField.superview?.addSubview(button)
            ac.view.layoutIfNeeded()
            button.frame = textField.superview?.bounds ?? .zero
        })
    }
    
    
//  alert view implementation
    func buttonTapped(message: String, title: String, buttonName: String) {
//      setting default category as other
        selectedCategoryForMoneyAdded = "Other"
        selectedCategoryForMoneySpent = "Other"
        
        let ac = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)

//      adding a text field
        ac.addTextField { (textField) in
            textField.placeholder = "Enter Amount"
            textField.keyboardType = .numberPad // getting the num pad up
        }
        
//      showing categories based on the button clicked
        if buttonName == "addMoney" {
            categories(ac: ac, categoryType: categoriesAddMoney, isEditButton: false)
        } else {
            categories(ac: ac, categoryType: categoriesSpentMoney, isEditButton: false)
        }
        
        
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
        
//      adding the buttons
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
             
        
        // current date store in this variable
        let currentDate = getCurrentDate()
        
//        let lastIndex = transactionList.count
        
        var transOne: cellData
        
//      add the cell data and displaying it according to the button name given
        if buttonName == "addMoney" {
            transOne = cellData(amount: "+ \(numberFormatted!) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-recieve", moneySpentOrRecievedBGImage: "Green Gradient", imageCategoryIcon: "\(selectedCategoryForMoneyAdded ?? "Other")")
//          editing current balance label
            editingLabelNumber(numberEntered: numberEntered ?? 0, symbol: "-")
        } else {
            transOne = cellData(amount: "- \(numberFormatted!) Rs", date: "\(currentDate)", moneySpentOrRecievedImage: "money-send", moneySpentOrRecievedBGImage: "Red Gradient", imageCategoryIcon: "\(selectedCategoryForMoneySpent ?? "Other")")
//          editing current balance label
            editingLabelNumber(numberEntered: numberEntered ?? 0, symbol: "+")
        }
        
        addTransaction(transOne)
        
        // adding new row at top such that latest result remains on top
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        return
    }
    
    
    func editAlertView(_ indexPath: IndexPath) {
//      creating an alert view controller
        let ac = UIAlertController(title: nil, message: "Edit or Delete", preferredStyle: .alert)
//      selecting the number from transaction list
        let numberAmount = transactionList[indexPath.row].amount
        let numberString = numberAmount.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let number = Int(numberString)
        var typeOfTransaction: String?
        
//      setting previous category in the category button
        let oldCategory = transactionList[indexPath.row].imageCategoryIcon
        
//      setting category and displaying it in placeholder
        selectedCategoryForMoneyAdded = oldCategory
        selectedCategoryForMoneySpent = oldCategory
        
//      setting that number in text field
        ac.addTextField { (textField) in
            textField.text = "\(number ?? 0)"
            textField.keyboardType = .numberPad // getting the num pad up
        }
        
//      checking for the type of transaction
        typeOfTransaction = transactionList[indexPath.row].imageMoneySpentOrRecieved

//      showing categories accordinglt
        if typeOfTransaction == "money-send" {
            categories(ac: ac, categoryType: categoriesSpentMoney, isEditButton: true)
        } else {
            categories(ac: ac, categoryType: categoriesAddMoney, isEditButton: true)
        }
        
//      adding submit button functionality
        let EditAction = UIAlertAction(title: "Edit",
                                         style: .default) { [unowned self, ac] action in
            
//          This is the text entry after enter key
            let AddedItem = ac.textFields![0]

//          checking the type of transaction by image name
            let typeOfTransaction = transactionList[indexPath.row].imageMoneySpentOrRecieved
            
            
//          saving previous number entered
            let previousAmountNumber = transactionList[indexPath.row].amount
            let numberAmountSplit = previousAmountNumber.split(separator: " ")
//          removing the comma from the number
            let numberWithoutComma = numberAmountSplit[1].replacingOccurrences(of: ",", with: "")
            let amountNumber = Int(numberWithoutComma)

//          adding or subtracting it based on waht kind of transaction it was
            if typeOfTransaction == "money-send" {
                currentbalanceNumber += amountNumber ?? 0
            } else {
                currentbalanceNumber -= amountNumber ?? 0
            }
            
            
            
//          checking if the number entered is nil or zero
            let numEntered = Int(AddedItem.text!)
            if typeOfTransaction == "money-send" {
                if numEntered != 0 || numEntered != nil {
//                  if the number entered is anything other than nil or zero perform operation and update the table
//                  view cell
//                  updating the current number variable
                    updatingRow(transactionType: typeOfTransaction, AddedItem: AddedItem, numEntered: numEntered ?? 0, indexPath: indexPath)
                }
            } else {
                if numEntered != 0 || numEntered != nil {
//                  if the number entered is anything other than nil or zero perform operation and update the table
//                  view cell
//                  updating the current number variable
                    updatingRow(transactionType: typeOfTransaction, AddedItem: AddedItem, numEntered: numEntered ?? 0, indexPath: indexPath)
                }
            }
        }
        
        
//      creating a Delete button
        let deleteButton = UIAlertAction(title: "Delete",
                                         style: .default) { _ in
            let AddedItem = ac.textFields![0]
            let numEntered = Int(AddedItem.text!)
            let typeOfTransaction = self.transactionList[indexPath.row].imageMoneySpentOrRecieved
            if typeOfTransaction == "money-send" {
                self.editingLabelNumber(numberEntered: numEntered ?? 0, symbol: "-")
            } else {
                self.editingLabelNumber(numberEntered: numEntered ?? 0, symbol: "+")
            }
            self.transactionList.remove(at: indexPath.row)
            
            let indexPaths = [indexPath]
            self.tableView.deleteRows(at: indexPaths, with: .automatic)
            
        }
        
        
//      setting delete button color and edit button color
        deleteButton.setValue(UIColor(hex: "#FF6C71"), forKey: "titleTextColor")
        EditAction.setValue(UIColor(hex: "#008000"), forKey: "titleTextColor")
        
//      adding the button
        ac.addAction(EditAction)
        ac.addAction(deleteButton)
        present(ac, animated: true)

    }
    
//  function to edit label number
    func editingLabelNumber(numberEntered: Int, symbol: String) {
        if symbol == "-" {
//          updating current balance label
            currentbalanceNumber += numberEntered
        } else {
//          updating current balance label
            currentbalanceNumber -= numberEntered
        }
        let currentBalanceFormatted = numberFormat(number: currentbalanceNumber)
        labelCurrentBalance.text = "\(currentBalanceFormatted) Rs  "
    }
//  updating row after updating the values
    func updatingRow(transactionType: String, AddedItem: UITextField, numEntered: Int, indexPath: IndexPath) {
        let addedItemNumber = Int(AddedItem.text!) ?? 0
        let number = numberFormat(number: addedItemNumber)
        let indexPaths = [indexPath]
        if transactionType == "money-send" {
//          editing label number
            editingLabelNumber(numberEntered: numEntered, symbol: "+")
            self.transactionList[indexPath.row].amount = "- \(number) Rs"
            transactionList[indexPath.row].imageCategoryIcon = selectedCategoryForMoneySpent ?? "Other"
        } else {
//          editing label number
            editingLabelNumber(numberEntered: numEntered, symbol: "-")
            self.transactionList[indexPath.row].amount = "+ \(number) Rs"
            transactionList[indexPath.row].imageCategoryIcon = selectedCategoryForMoneyAdded ?? "Other"
          }
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
//  method for table view cell for row at
    func cellConfiguration(cell: TrackerCell, indexPath: IndexPath) -> UITableViewCell {
//        setting data of cell to display
        cell.labelAmountData.text = "\(transactionList[indexPath.row].amount)"
        cell.labelDateData.text = "\(transactionList[indexPath.row].date)"
        cell.imageTransactionStatus.image = UIImage(named: transactionList[indexPath.row].imageMoneySpentOrRecieved)
        cell.imageTransactionStatusBG.image = UIImage(named: transactionList[indexPath.row].imageMoneySpentOrRecievedBG)
        cell.imageTransactionCategory.image = UIImage(named: transactionList[indexPath.row].imageCategoryIcon)
        
//      setting background color to transparent such that there remains a space between two cells
        cell.layer.backgroundColor = UIColor.clear.cgColor
//      setting background imgage radius of the cell such that uniformity is obtained and it looks like a cell
        cell.imageTransactionStatusBG.layer.cornerRadius = 15
        return cell
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

//      calling a function containing all cell configuration
        return cellConfiguration(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editAlertView(indexPath)
    }
}

extension MoneyTrackerVC {
    
//  add money button
    @IBAction func addMoney(_ sender: Any) {
//      function to check which button is tapped
        buttonTapped(message: "Income", title: "Add", buttonName: "addMoney")
    }
    
//  money spent button
    @IBAction func spentMoney(_ sender: Any) {
//      function to check which button is tapped
        buttonTapped(message: "Expense", title: "Spent", buttonName: "spentMoney")
    }
}
