//
//  Random.swift
//  iOS-SlotMachine
//
//  Created by Student on 2018-02-05.
//  Copyright © 2018 Rafael Matos. All rights reserved.
//

import Foundation

class Random {
        
    // Probability of rolling each fly/fruit
    let SYMBOL_1      = 0.5
    let SYMBOL_2      = 1.0
    let SYMBOL_3      = 0.2
    let APPLE      = 5.0
    let BANANA     = 7.0
    let CHERRY     = 3.0
    let LYMON      = 4.0
    let SEVEN = 8.0
    let GRAPE = 4.0
    let PARDBERRY = 6.0
   
    
    public func weightedRandom() -> Int {
        return getRandomNumber(probabilities: [
          SYMBOL_1,
          SYMBOL_2,
          SYMBOL_3,
          APPLE,
          BANANA,
          CHERRY,
          LYMON,
          SEVEN,
          GRAPE,
          PARDBERRY
        ])
    }
    
    private func getRandomNumber(probabilities: [Double]) -> Int {
        
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
}
