//
//  AdditionalViewController.swift
//  Memory
//
//  Created by Артем Жорницкий on 18/04/2019.
//  Copyright © 2019 Максим Витовицкий. All rights reserved.
//

import Foundation
import UIKit

class AdditionalViewController : UIViewController {
    
    var time: String?
    var date: Date?
    var number: Int?
    var numberOfTaps: Int?
    let formatter = DateFormatter()
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        super.viewDidLoad()
        
        if number != nil {
            setupForNumber()
        }
        else {
            setupForResult()
        }
    }
    
    
    func setupForResult() {
        numberLabel.isHidden = true
        dateLabel.isHidden = false
        timeLabel.isHidden = false
        mainLabel.isHidden = false
        dateLabel.text = "Date of your game : \n" + formatter.string(from: date!)
        timeLabel.text = "Time in game : \n \(time!)"
        mainLabel.text = "Number of taps : \n \(numberOfTaps!)"
    }
    func setupForNumber() {
        numberLabel.text = "\(number!)"
        dateLabel.isHidden = true
        timeLabel.isHidden = true
        mainLabel.isHidden = true
    }
}
