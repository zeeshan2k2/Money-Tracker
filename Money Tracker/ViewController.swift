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
    }
    

    var arrSample = ["200", "300", "200", "400", "500", "700"]
    
    @IBOutlet var currentBalance: UILabel!
    
    @IBOutlet var StackViewBGImage: UIImageView!

    @IBOutlet var moneyAddAndSpentBGImage: UIImageView!
    
    func applyBorderRadius() {
        StackViewBGImage.layer.cornerRadius = 55
        moneyAddAndSpentBGImage.layer.cornerRadius = 30
        currentBalance?.layer.cornerRadius = 8
        currentBalance?.layer.masksToBounds = true
        
    }
    
    @IBOutlet var tableView: UITableView!
        
    
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSample.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = arrSample[indexPath.section]
        
        return cell
    }
    
}
