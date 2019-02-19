import UIKit

extension UIPickerView {
    
    func flash(_ color: UIColor) {
        UIView.animate(withDuration: ViewController.flashIntervalAnimation, delay: ViewController.delayAnimation, animations: {
            self.backgroundColor = color
        }, completion: flashFade)
        
    }
    func paint() {
        self.backgroundColor = MyColor.lightBlue
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
        self.layer.borderColor = MyColor.darkBlue.cgColor
    }
    
    private func flashFade(_ finished: Bool) {
        if (!finished) {
            return
        }
        UIView.animate(withDuration: ViewController.intervalAnimation, animations: {
            self.backgroundColor = MyColor.lightBlue
        }, completion: nil)
    }
}
