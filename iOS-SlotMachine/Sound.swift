//
//  Sound.swift
//  iOS-SlotMachine
//
//  Created by Student on 2018-02-05.
//  Copyright © 2018 Rafael Matos. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    var coinPlayer = AVAudioPlayer()
    
    var startPlayer = AVAudioPlayer()
    var symbolPlayer  = AVAudioPlayer()
    var litlePayOutPlayer = AVAudioPlayer()
    var manyPayOutPlayer = AVAudioPlayer()
    var deadPlayer = AVAudioPlayer()
    
    public func loadOfSound( filename: String, type: String = ".mp3") -> AVAudioPlayer {
        let DIR = "Sounds/"
        var soundPlayer: AVAudioPlayer? = nil
        let sound = Bundle.main.path(forResource: DIR + filename, ofType: type)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound! ))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }catch{
            print(error)
        }
        soundPlayer?.prepareToPlay()
        return soundPlayer!
    }
    
    public func Start() {
     
        startPlayer = loadOfSound(filename: "itemreel", type: ".wav")
        symbolPlayer  = loadOfSound(filename: "fly-1")
        litlePayOutPlayer = loadOfSound(filename: "short-payout")
        manyPayOutPlayer = loadOfSound(filename: "rich-payout") //jackpot
        deadPlayer = loadOfSound(filename: "deep-gulp")
        coinPlayer = loadOfSound(filename: "insertingCoin")
    }
}
