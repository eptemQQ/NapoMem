//
//  MenuViewController.swift
//  Memory
//
//  Created by Артем Жорницкий on 18/04/2019.
//  Copyright © 2019 Максим Витовицкий. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UIViewController {
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.layer.cornerRadius = playButton.frame.size.height / 2
        }
    }
    
    @IBOutlet weak var resultButton: UIButton! {
        didSet {
            resultButton.layer.cornerRadius = resultButton.frame.size.height / 2
        }
    }
    @IBAction func resultTapped(_ sender: Any) {
        let tableviewVC = SecondViewController.instance() as! SecondViewController
        tableviewVC.fromResult = true
        tableviewVC.navigationItem.title = "Results"
        navigationController?.pushViewController(tableviewVC, animated: true)
    }
}
