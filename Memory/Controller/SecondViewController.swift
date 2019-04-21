//
//  SecondViewController.swift
//  Memory
//
//  Created by Артем Жорницкий on 16/04/2019.
//  Copyright © 2019 Максим Витовицкий. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    var fromResult = false
    let numberOfCells = 20
    var arrayOfNums = [Int]()
    var arrayOfResults = [Result]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if arrayOfNums.isEmpty {
            fillRandomArray()
        }
        if fromResult {
            getData()
            if arrayOfResults.isEmpty {
                tableView.isHidden = true
            }
        }
    }
    
    func fillRandomArray() {
        for _ in 0...numberOfCells {
            arrayOfNums.append(Int.random(in: 0 ..< 20))
        }
    }
    func getData() {
        if let x = UserDefaults.standard.object(forKey: "result") as? Array<Int> {
            let y = UserDefaults.standard.object(forKey: "date") as? Array<Date>
            let z = UserDefaults.standard.object(forKey: "timeInGame") as? Array<String>
            for index in 0...(x.count-1) {
                arrayOfResults.append(Result(numberOfTaps: x[index], timeInGame: z![index], date: y![index]))
            }
            arrayOfResults.sort(by: { $0.numberOfTaps < $1.numberOfTaps })
            for index in 0...(arrayOfResults.count-1) {
                print(arrayOfResults[index].numberOfTaps)
            }
        }
    }
    
}
extension SecondViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let additionalVC = AdditionalViewController.instance() as! AdditionalViewController
        if fromResult {
            additionalVC.numberOfTaps = arrayOfResults[indexPath.row].numberOfTaps
            additionalVC.date = arrayOfResults[indexPath.row].date
            additionalVC.time = arrayOfResults[indexPath.row].timeInGame
             additionalVC.navigationItem.title = "Result Info"
            navigationController?.pushViewController(additionalVC, animated: true)
        }
        else {
            additionalVC.number = arrayOfNums[indexPath.row]
            additionalVC.navigationItem.title = "Number Info"
            navigationController?.pushViewController(additionalVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
extension SecondViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fromResult {
            return UserDefaults.standard.array(forKey: "result")?.count ?? 0
        }
        else {
            return numberOfCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewControllerCell
        if fromResult == false {
            cell.myLabel.text = "\(arrayOfNums[indexPath.row])"
        }
        else {
            cell.myLabel.text = "\(arrayOfResults[indexPath.row].numberOfTaps)"
        }
        return cell
    }
}

