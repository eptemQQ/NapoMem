//
//  ViewController.swift
//  Memory
//
//  Created by Maxim Vitovitsky on 29/03/2019.
//  Copyright © 2019 Максим Витовицкий. All rights reserved.
//

import UIKit

var kekArray = [Int]()

class ViewController: UIViewController {
    
    var tapArray = [Int]()
    var dateArray = [Date]()
    var timeArray = [String]()
    
    var date : Date!
    
    var timer = Timer()
    var timeString  = String()
    
    var seconds = 0
    var minutes = 0
    
    var winAlert: UIAlertController!
    var yes: UIAlertAction!
    
    var tapCounter = 0
    
    var results = [Result]()
    
    var game: Memory!
    
    var emojiList: [String]!
    var emoji: [Int:String]!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    
    @IBOutlet weak var restartButton: UIButton! {
        didSet {
            restartButton.layer.cornerRadius = restartButton.frame.size.height / 2
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        newGame()
    }
    
    @IBAction func cardButtonAction(_ sender: UIButton) {
        tapCounter+=1
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateButtons()
        } else {
            print("This button is not in card buttons!")
        }
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        newGame()
        createAlert()
        saveData()
    }
    
    func updateButtons() {
        
        if game.chosenCards.count == 1 {
            let firstIndex = game.chosenCards[0]
            cardFaceUp(button: cardButtons[firstIndex], indexAtCardsArray: firstIndex)
            cardButtons[firstIndex].isEnabled = false
        }
        else  {
            let secondIndex = game.chosenCards[1]
            let firstIndex = game.chosenCards[0]
            let firstButton = cardButtons[firstIndex]
            let secondButton = cardButtons[secondIndex]
            cardFaceUp(button: secondButton, indexAtCardsArray: secondIndex)
            if  game.checkYourChoose() {
                self.game.cards[firstIndex].isMatched = true
                self.game.cards[secondIndex].isMatched = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.setupIfTruePair(firstButton: firstButton, secondButton: secondButton)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)  ) {
                    self.setupIfWrongPair(firstButton: firstButton, secondButton:  secondButton)
                }
            }
            cardButtons[firstIndex].isEnabled = true
            game.chosenCards.removeAll()
            if checkIfGameIsOver() {
                present(winAlert, animated: true)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.id] == nil, emojiList.count > 0 {
            let randomIndex = Int.random(in: 0..<emojiList.count)
            emoji[card.id] = emojiList.remove(at: randomIndex)
        }
        return emoji[card.id] ?? "?"
    }
    
    func cardFaceUp(button : UIButton, indexAtCardsArray: Int) {
        button.setTitle(emoji(for: game.cards[indexAtCardsArray]), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func setupIfWrongPair(firstButton: UIButton,secondButton: UIButton) {
        firstButton.backgroundColor = #colorLiteral(red: 0.2723996043, green: 0.6819463372, blue: 0.632582128, alpha: 1)
        firstButton.setTitle("", for: .normal)
        secondButton.backgroundColor = #colorLiteral(red: 0.2723996043, green: 0.6819463372, blue: 0.632582128, alpha: 1)
        secondButton.setTitle("", for: .normal)
    }
    
    func setupIfTruePair(firstButton: UIButton,secondButton: UIButton) {
        firstButton.backgroundColor = .white
        firstButton.setTitle("", for: .normal)
        firstButton.isEnabled = false
        secondButton.backgroundColor = .white
        secondButton.setTitle("", for: .normal)
        secondButton.isEnabled = false
    }
    
    func checkIfGameIsOver() -> Bool {
        var counter = 0
        
        for index in cardButtons.indices {
            if game.cards[index].isMatched {
                counter += 1
            }
        }
        if counter == cardButtons.count {
            timer.invalidate()
            updateData()
            return true
        }
        else {
            return false
        }
    }
    
    func newGame() {
        startTimer()
        date = Date()
        tapCounter = 0
        game = Memory(numberOfCardPairs: (cardButtons.count + 1) / 2)
        game.chosenCards.removeAll()
        for index in cardButtons.indices {
            cardButtons[index].isEnabled = true
            cardButtons[index].backgroundColor = #colorLiteral(red: 0.2723996043, green: 0.6819463372, blue: 0.632582128, alpha: 1)
            cardButtons[index].setTitle("", for: .normal)
            emojiList = ["🦊", "🐻", "🐼", "🐨", "🦁", "🐯", "🐵", "🦉", "🦇"]
            emoji = [Int:String]()
            
        }
    }
    
    func createAlert() {
        winAlert = UIAlertController(title: "You won!", message: "Do you want to restart?", preferredStyle: .alert)
        yes = UIAlertAction(title: "Yes", style: .default) { _ in self.newGame() }
        winAlert.addAction(yes)
    }
    
    // work with timer
    func startTimer() {
        seconds = 0
        minutes = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        seconds += 1
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        
        timeString = String(format: "%02d:%02d", minutes, seconds)
    }
    //work with UserDefaults
    func saveData() {
        if let x = UserDefaults.standard.object(forKey: "result") as? Array<Int> {
            if let y = UserDefaults.standard.object(forKey: "date") as? Array<Date> {
                if let z = UserDefaults.standard.object(forKey: "timeInGame") as? Array<String> {
                    tapArray = x
                    dateArray = y
                    timeArray = z
                }
            }
        }
        else {
            print("No data to save")
        }
    }
    
    func updateData() {
        dateArray.append(date)
        timeArray.append(timeString)
        tapArray.append(tapCounter)
        UserDefaults.standard.set(tapArray, forKey: "result")
        UserDefaults.standard.set(timeArray, forKey: "timeInGame")
        UserDefaults.standard.set(dateArray, forKey: "date")
        UserDefaults.standard.synchronize()
    }
    
}


