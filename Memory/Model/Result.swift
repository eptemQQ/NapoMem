//
//  Result.swift
//  Memory
//
//  Created by Артем Жорницкий on 16/04/2019.
//  Copyright © 2019 Максим Витовицкий. All rights reserved.
//

import Foundation

class Result {
    var numberOfTaps : Int
    var timeInGame : String
    var date : Date
    init(numberOfTaps : Int, timeInGame : String, date : Date) {
        self.numberOfTaps = numberOfTaps
        self.timeInGame = timeInGame
        self.date = date
    }
}
