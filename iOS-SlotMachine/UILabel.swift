//https://www.andrewcbancroft.com/2014/07/27/fade-in-out-animations-as-class-extensions-with-swift/#fade-without-extension

import Foundation
import UIKit

extension UILabel {
   
    func moveTo() {
        UIView.animate(withDuration: ViewController.intervalAnimation + ViewController.countingIntervalAnimation, delay: ViewController.delayAnimation, animations: {
            self.frame = self.frameOffset(self.frame, ViewController.animationOffSet)
        }, completion: moveBack)
    }
    func pop() {
        self.isHidden = false
        self.moveTo()
        self.saddenIn()
    }
    func moveBack(_ finished: Bool) {
        self.frame = self.frameOffset(self.frame, -ViewController.animationOffSet)
    }
    
    func saddenOut(_ finished: Bool = true) {
        if (!finished) {
            return
        }
        UIView.animate(withDuration: ViewController.intervalAnimation, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: hidde)
    }
    func saddenIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: ViewController.countingIntervalAnimation, delay: ViewController.delayAnimation, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: saddenOut)
    }
    private func frameOffset(_ frame: CGRect, _ offset: CGFloat) -> CGRect {
        return CGRect(x: frame.origin.x, y: frame.origin.y - offset, width: frame.size.width, height: frame.size.height)
        
    }
    func hidde(_ finished: Bool) {
        self.isHidden = true
    }
}
