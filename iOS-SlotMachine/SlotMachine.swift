import Foundation
import SpriteKit
import UIKit

class SlotMachine {
    
    var elementsCount: Int
    var flieCount: Int
    var selectedElement1: Int
    var selectedElement2: Int
    var selectedElement3: Int
    var selectedElement4: Int
    var selectedElement5: Int
    var emptyRow: Int
    
    var winning: Int
    var moneys: Int
    var rate: Int
    var bonusInGame: Int
    var matchedElement: Int
    
    var sounds: Sound = Sound()
    var random: Random = Random()
    
    var disableFiveD: Bool
    var disableFiftyD: Bool
    var nullRate: Bool
    var isWinning: Bool
    var symbol: Bool
    
    init(ElementsCount elementsCount: Int, FlieCount flieCount: Int = 3) {
        self.elementsCount = elementsCount
        self.flieCount = flieCount
        self.emptyRow = self.elementsCount
/**/
        // start with 5 "blanks"
        self.selectedElement1 = self.emptyRow
        self.selectedElement2 = self.emptyRow
        self.selectedElement3 = self.emptyRow
        self.selectedElement4 = self.emptyRow
        self.selectedElement5 = self.emptyRow
/**/
        self.winning = 0
        self.moneys = 0
        self.rate = 0
        self.bonusInGame = 0
        self.matchedElement = self.emptyRow
        
        self.disableFiveD = true
        self.disableFiftyD = true
        self.nullRate = true
        self.isWinning = false
        self.symbol = false
        
        sounds.Start()
    }

    public func insertValue(Value value: Int) {
        self.moneys += value
        
        if (self.moneys >= 5) {
            self.disableFiveD = false
        }
        
        if (self.moneys >= 50) {
            self.disableFiftyD = false
        }
    }
    
    public func reset() {
        //call init?
        
    }
    public func resetRate() {
        self.rate = 0
        self.nullRate = true
    }
    public func resetWinning() {
        self.winning = 0
        self.isWinning = false
    }
    
    public func resetSymbol() {
        self.symbol = false
    }
    public func resetMyBonus() {
        self.bonusInGame = 0
    }
    
    
    public func start() {
        startReels()
        calculateMyBonus()
    }
    public func rate(Value value: Int) -> Bool {
        // Only bet what you have
        if (value > self.moneys) {
            return false
        }
        
        self.rate += value
        self.winning += value   // sum all bets for jackpot prize
        self.moneys -= value
        
        if (self.moneys < 5) {
            self.disableFiveD = true
        }
        if (self.moneys < 50) {
            self.disableFiftyD = true
        }
        
        self.nullRate = false
        return true
    }
    private func flieSelected() -> Bool {
        // check for flies (first rows)
        self.symbol = false
        if (self.selectedElement1 < self.flieCount) { self.symbol = true }
        if (self.selectedElement2 < self.flieCount) { self.symbol = true }
        if (self.selectedElement3 < self.flieCount) { self.symbol = true }
        if (self.selectedElement4 < self.flieCount) { self.symbol = true }
        if (self.selectedElement5 < self.flieCount) { self.symbol = true }
        return self.symbol
    }
    
    private func calculateMyBonus() {
        self.resetMyBonus()
        self.resetSymbol()
        
        if (!self.flieSelected()) {
            self.matchElements()
            
            if (bonusInGame > 0) {
                self.moneys += bonusInGame
            }
        }
        self.resetRate()
        
        print("Bonus = ", bonusInGame)  // write bonus in the log
    }
    
    private func startReels() {
        self.selectedElement1 = randomize()
        self.selectedElement2 = randomize()
        self.selectedElement3 = randomize()
        self.selectedElement4 = randomize()
        self.selectedElement5 = randomize()
    }
    
    private func matchElements() {
        matchElement(self.selectedElement1)
        matchElement(self.selectedElement2)
        matchElement(self.selectedElement3)
        // since 3 or more fruits are needed,
        // we do not need to compare for
        // selected4 and selected5
    }
    
    private func matchElement(_ fruit: Int) {
        let count = matches(fruit)
        awardRepeatedElements(count)
        if (count > 2) {
            self.matchedElement = fruit
        }
    }
    
    private func matches(_ element: Int) -> Int {
        // returns how many fruits there are equal to the passed one.
        var count: Int = 0
        if (isSameElement(self.selectedElement1, element)) { count = count + 1 }
        if (isSameElement(self.selectedElement2, element)) { count = count + 1 }
        if (isSameElement(self.selectedElement3, element)) { count = count + 1 }
        if (isSameElement(self.selectedElement4, element)) { count = count + 1 }
        if (isSameElement(self.selectedElement5, element)) { count = count + 1 }
        return count
    }
    private func awardRepeatedElements(_ count: Int) {
        if (count == 5) {
            self.moneys += self.winning
            bonusInGame = self.winning
            self.isWinning = true
        } else if (count == 4) {
            bonusInGame = self.rate * 3
        } else if (count == 3) {
            bonusInGame = self.rate * 2
        }
        //no award for 2 or 1 repeated fruits
    }
    private func randomize() -> Int {
        return self.weightedRand()
    }
    
    private func isSameElement(_ element1: Int, _ element2: Int) -> Bool {
        if element1 == element2 { return true }
        else { return false }
    }
    
    
    private func uniformRandom() -> Int {
        return Int(arc4random_uniform(UInt32(self.elementsCount)))
    }
    private func setAll( _ row: Int) {
        self.selectedElement1 = row
        self.selectedElement2 = row
        self.selectedElement3 = row
        self.selectedElement4 = row
        self.selectedElement5 = row
    }
    
    private func weightedRand() -> Int {
        return random.weightedRandom()
    }
}

