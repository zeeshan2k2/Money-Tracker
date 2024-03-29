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
        applyBorderRadius()
    }
    
    @IBOutlet var currentBalance: UILabel!
    
    @IBOutlet var StackViewBGImage: UIImageView!

    @IBOutlet var moneyAddAndSpentBGImage: UIImageView!
    
    func applyBorderRadius() {
        StackViewBGImage.layer.cornerRadius = 55
        moneyAddAndSpentBGImage.layer.cornerRadius = 30
        currentBalance?.layer.cornerRadius = 8
        currentBalance?.layer.masksToBounds = true
    }
    
}

