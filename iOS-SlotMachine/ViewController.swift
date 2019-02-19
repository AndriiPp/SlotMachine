//
//  ViewController.swift
//  iOS-SlotMachine
//
//  Created by Rafael Timbo 300962678,
//  Fernando Ito 300960367
//  and Sergio Brunacci 300910506
//  on 2018-02-04.
//  Copyright © 2018 Rafael Matos. All rights reserved.
//  App: Watermelon Jackpot 1.0
//  A Slot machine game with a kitchen theme that uses fruits as slot items, and flies as fail
//  To win you need to get 3 or more equal fruits and no flies.

import UIKit
import SpriteKit

class ViewController: UIViewController, UIPickerViewDelegate {

    static let delayAnimation = 0.5
    static let intervalAnimation = 3.0
    static let flashIntervalAnimation = 0.2
    static let countingIntervalAnimation = 1.0
    static let animationOffSet: CGFloat = 40
    
    
    // Original UIImage
    let elements: [UIImage] = [
        #imageLiteral(resourceName: "bIcon"),
        #imageLiteral(resourceName: "gIcon"),
        #imageLiteral(resourceName: "lIcon"),
        #imageLiteral(resourceName: "appleIcon"),
        #imageLiteral(resourceName: "bananaIcon"),
        #imageLiteral(resourceName: "cheryIcon"),
        #imageLiteral(resourceName: "limonIcon"),
        #imageLiteral(resourceName: "sevenIcon"),
        #imageLiteral(resourceName: "raspberryIcon"),
        #imageLiteral(resourceName: "grapeIcon")
    ]
    
    var playing: SlotMachine
    var sounds: Sound = Sound()
    
    @IBOutlet weak var element1: UIPickerView!
    
    @IBOutlet weak var element2: UIPickerView!
    
    @IBOutlet weak var element3: UIPickerView!
    
    @IBOutlet weak var element4: UIPickerView!
    
    @IBOutlet weak var element5: UIPickerView!
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var money1Button: UIButton!
    @IBOutlet weak var money2Button: UIButton!
    @IBOutlet weak var rateFive: UIButton!
    @IBOutlet weak var rateFifty: UIButton!
    
    @IBOutlet weak var moneyTableView: UIView!
    
    @IBOutlet weak var rateTableView: UIView!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    //UI placeholders, reserve space on storyboard for actual variables below
    @IBOutlet weak var moneys: UILabel!
    @IBOutlet weak var rates: UILabel!
    @IBOutlet weak var winnings: UILabel!
    
    //Animated-counting labels
    var money: AnimateLabel
    var rate: AnimateLabel
    var winning: AnimateLabel
    
    @IBOutlet weak var payout: UILabel!
    
    @IBOutlet weak var winningHeader: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        self.playing = SlotMachine(ElementsCount: elements.count)
        self.money = AnimateLabel()
        self.rate = AnimateLabel()
        self.winning = AnimateLabel()
        
        sounds.Start()
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paintElements()
        self.setupLabelsAnimated()
        self.draw()
    }
    
    private func setupLabelsAnimated() {
        //substitute UILabels to AnimatedLabels
        
        money.copyLab(Label:moneys)
        moneys.isHidden = true
        moneyTableView.addSubview(money)
        
        rate.copyLab(Label: rates)
        rates.isHidden = true
        rateTableView.addSubview(rate)
        
        winning.copyLab(Label: winnings)
        winnings.isHidden = true
        winningHeader.addSubview(winning)
        
    }
    
    private func paintElements() {
        startButton.buttonize(6, startButton.frame.width / 2)
        startButton.clipsToBounds = true
        startButton.layer.borderColor = MyColor.darkBlue.cgColor
        
        exitButton.buttonize(3, exitButton.frame.height / 3)
        exitButton.layer.borderColor = MyColor.darkBlue.cgColor
        resetButton.buttonize(3, exitButton.frame.height / 3)
        resetButton.layer.borderColor = MyColor.darkBlue.cgColor
        
        moneyTableView.layer.borderColor = MyColor.darkBlue.cgColor
        moneyTableView.layer.borderWidth = 2
        moneyTableView.layer.cornerRadius = 20
        
        rateTableView.layer.borderColor = MyColor.darkBlue.cgColor
        rateTableView.layer.borderWidth = 2
        rateTableView.layer.cornerRadius = 20
        
        winningHeader.layer.cornerRadius = winningHeader.bounds.height / 3
        setAllPickersColor()
        PickerUserInteractionIsDisabled()
        view.backgroundColor = UIColor.white
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return #imageLiteral(resourceName: "grapeIcon").size.height + 10 // + 10 is padding
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elements.count + 1 // + 1 for starting empty row
    }
  
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let width: Int = Int(pickerView.bounds.width) - 30
        let height = 120
        
        //let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height:fruits[row].size.height))
        let myView = UIView(frame: CGRect(x:0, y:0, width: width, height:height))
        
        //blank row
        if (row == elements.count) {
            return myView
        }
        
        //let myImageView = UIImageView(frame: CGRect(x:0, y:0, width: fruits[row].size.width, height: fruits[row].size.height))
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        myImageView.image = elements[row]
        myView.addSubview(myImageView)
        
        return myView
    }
    private func setAllPickersColor() {
        element1.paint()
        element2.paint()
        element3.paint()
        element4.paint()
        element5.paint()
    }
    private func PickerUserInteractionIsDisabled() {
        element1.isUserInteractionEnabled = false
        element2.isUserInteractionEnabled = false
        element3.isUserInteractionEnabled = false
        element4.isUserInteractionEnabled = false
        element5.isUserInteractionEnabled = false
        
    }
    private func drawReel() {
        // return all pickers to last line so all reels rolls up on animation
        element1.selectRow(playing.emptyRow, inComponent: 0, animated: false)
        element2.selectRow(playing.emptyRow, inComponent: 0, animated: false)
        element3.selectRow(playing.emptyRow, inComponent: 0, animated: false)
        element4.selectRow(playing.emptyRow, inComponent: 0, animated: false)
        element5.selectRow(playing.emptyRow, inComponent: 0, animated: false)

        // display selected rows in an animated fashion
        element1.selectRow(playing.selectedElement1, inComponent: 0, animated: true)
        element2.selectRow(playing.selectedElement2, inComponent: 0, animated: true)
        element3.selectRow(playing.selectedElement3, inComponent: 0, animated: true)
        element4.selectRow(playing.selectedElement4, inComponent: 0, animated: true)
        element5.selectRow(playing.selectedElement5, inComponent: 0, animated: true)
    }
    private func displayMyBonus() {
        if (playing.isWinning) {
            sounds.manyPayOutPlayer.play()
            playing.resetWinning()
            self.winning.countFromCurrentValue(to: Float(0.0), duration: ViewController.countingIntervalAnimation)
            payout.text = "$" + String(playing.bonusInGame)
            payout.pop()
            self.flashPicker()
        }
        else if (playing.bonusInGame > 0) {
            sounds.litlePayOutPlayer.play()
            payout.text = "$" + String(playing.bonusInGame)
            payout.pop()
            self.flashPicker()
        } else {
            //sound.lostPlayer.play()
            payout.text = "$0"
            
        }
        playing.resetMyBonus()
        
        if (playing.symbol) {
            flashAllPicker()
            sounds.symbolPlayer.play()
            playing.resetSymbol()
        }
    }
    private func drawValue() {
        self.money.countFromCurrentValue(to: Float(playing.moneys), duration: ViewController.countingIntervalAnimation)
        self.rate.countFromCurrentValue(to: Float(playing.rate), duration: ViewController.countingIntervalAnimation)
        self.winning.countFromCurrentValue(to: Float(playing.winning), duration: ViewController.countingIntervalAnimation)
        
        self.disableBRateIfNeeded()
    }
    
    private func draw() {
        //update the UI on each game tick
        self.drawReel()
        self.drawValue()
        self.displayMyBonus()
    }
    
   
    
    
    private func flashAllPicker() {
        element1.flash(MyColor.gray)
        element2.flash(MyColor.gray)
        element3.flash(MyColor.gray)
        element4.flash(MyColor.gray)
        element5.flash(MyColor.gray)
    }
    private func flashPicker() {
        if (playing.selectedElement1 == playing.matchedElement) {
            element1.flash(MyColor.yellow)
        }
        if (playing.selectedElement2 == playing.matchedElement) {
            element2.flash(MyColor.yellow)
        }
        if (playing.selectedElement3 == playing.matchedElement) {
            element3.flash(MyColor.yellow)
        }
        if (playing.selectedElement4 == playing.matchedElement) {
            element4.flash(MyColor.yellow)
        }
        if (playing.selectedElement5 == playing.matchedElement) {
            element5.flash(MyColor.yellow)
        }
    }
    
    private func disableBRateIfNeeded() {
        //betFive.isEnabled = !game.disableFive
        //betFifty.isEnabled = !game.disableFifty
        //spinButton.isEnabled = !game.nullBet
        
        rateFive.isSetEnabledAnimated(!playing.disableFiveD)
        rateFifty.isSetEnabledAnimated(!playing.disableFiftyD)
        startButton.isSetEnabledAnimated(!playing.nullRate)
    }

    
    @IBAction func addFifty(_ sender: UIButton) {
        playing.insertValue(Value:50)
        sounds.coinPlayer.play()
        self.drawValue()
    }
    @IBAction func addFive(_ sender: UIButton) {
        playing.insertValue(Value:5)
        sounds.coinPlayer.play()
        self.drawValue()
    }
    
    @IBAction func rateFifty(_ sender: UIButton) {
        if (!playing.rate(Value:50)) {
            print("Not enough Money to rate 50")
        }
        self.drawValue()
        sounds.coinPlayer.play()
    }
    @IBAction func restart(_ sender: UIButton) {
        //game.reset()
        print("Restart")
        playing = SlotMachine(ElementsCount: elements.count)
        self.draw()
    }
    
    @IBAction func start(_ sender: UIButton) {
        sender.pulsate()
        //spinPlayer.play()
        playing.start()

        self.draw()
        //spinPlayer.stop()
    }
    @IBAction func rateFive(_ sender: UIButton) {
        if (!playing.rate(Value:5)) {
            print("Not enough Money to rate 5")
        }
        self.drawValue()
        sounds.coinPlayer.play()
    }
    
    @IBAction func pressExit(_ sender: UIButton) {
        //suspend the app in second plan
        //UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}

