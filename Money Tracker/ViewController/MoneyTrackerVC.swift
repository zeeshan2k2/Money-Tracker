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
    private var transactions: [Transaction] = []

    private let repository = TransactionRepository(
        context: CoreDataStack.shared.context
    )
    
//  current balance variable
    @IBOutlet var labelCurrentBalance: UILabel!
    
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
        
//      loading transactions from CoreData
        loadTransactions()
    }
    
    private func loadTransactions() {
        do {
            transactions = try repository.fetchAll()
            updateBalance()
            tableView.reloadData()
        } catch {
            print("Failed to load:", error)
        }
    }
    
    private func updateBalance() {
        let balance = transactions.reduce(0) { result, transaction in
            switch transaction.type {
            case .income:
                return result + Int(transaction.amount)
            case .expense:
                return result - Int(transaction.amount)
            }
        }

        labelCurrentBalance.text = "\(numberFormat(number: balance)) Rs"
    }
    
    private func updateTransaction(oldTransaction: Transaction,
                                   newAmount: Double) {
        
        let updatedTransaction = Transaction(
            id: oldTransaction.id,
            amount: newAmount,
            date: oldTransaction.date,
            type: oldTransaction.type,
            category: oldTransaction.type == .income
                ? (selectedCategoryForMoneyAdded ?? "Other")
                : (selectedCategoryForMoneySpent ?? "Other")
        )
        
        do {
            try repository.update(updatedTransaction)
            loadTransactions()
        } catch {
            print("Update failed:", error)
        }
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
        
        guard let numberEntered = Double(item),
              numberEntered > 0 else {
            return
        }
        
        let transaction = Transaction(
            id: UUID(),
            amount: numberEntered,
            date: Date(),
            type: buttonName == "addMoney" ? .income : .expense,
            category: buttonName == "addMoney"
                ? (selectedCategoryForMoneyAdded ?? "Other")
                : (selectedCategoryForMoneySpent ?? "Other")
        )
        
        do {
            try repository.save(transaction)
            loadTransactions()
        } catch {
            print("Failed to save:", error)
        }
    }
    
    
    func editAlertView(_ indexPath: IndexPath) {
        
        let transaction = transactions[indexPath.row]
        
        let ac = UIAlertController(title: nil,
                                   message: "Edit or Delete",
                                   preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.text = String(Int(transaction.amount))
            textField.keyboardType = .numberPad
        }
        
        // Set previous category
        selectedCategoryForMoneyAdded = transaction.category
        selectedCategoryForMoneySpent = transaction.category
        
        if transaction.type == .expense {
            categories(ac: ac, categoryType: categoriesSpentMoney, isEditButton: true)
        } else {
            categories(ac: ac, categoryType: categoriesAddMoney, isEditButton: true)
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            guard let self = self,
                  let text = ac.textFields?.first?.text,
                  let newAmount = Double(text),
                  newAmount > 0 else {
                return
            }
            
            self.updateTransaction(
                oldTransaction: transaction,
                newAmount: newAmount
            )
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            do {
                try self.repository.delete(id: transaction.id)
                self.loadTransactions()
            } catch {
                print("Delete failed:", error)
            }
        }
        
        ac.addAction(editAction)
        ac.addAction(deleteAction)
        
        present(ac, animated: true)
    }
    
    func cellConfiguration(cell: TrackerCell, indexPath: IndexPath) -> UITableViewCell {
        
        let transaction = transactions[indexPath.row]
        
        // Format amount
        let formattedAmount = numberFormat(number: Int(transaction.amount))
        
        if transaction.type == .income {
            cell.labelAmountData.text = "+ \(formattedAmount) Rs"
            cell.imageTransactionStatus.image = UIImage(named: "money-recieve")
            cell.imageTransactionStatusBG.image = UIImage(named: "Green Gradient")
        } else {
            cell.labelAmountData.text = "- \(formattedAmount) Rs"
            cell.imageTransactionStatus.image = UIImage(named: "money-send")
            cell.imageTransactionStatusBG.image = UIImage(named: "Red Gradient")
        }
        
        // Format date properly
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        cell.labelDateData.text = formatter.string(from: transaction.date)
        
        // Category icon
        cell.imageTransactionCategory.image = UIImage(named: transaction.category)
        
        // UI styling
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.imageTransactionStatusBG.layer.cornerRadius = 15
        
        return cell
    }
    
}


extension MoneyTrackerVC: UITableViewDataSource, UITableViewDelegate {
    
//  setting number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
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
