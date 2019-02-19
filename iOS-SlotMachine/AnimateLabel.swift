import Foundation
import UIKit

enum AnimateDuration {
    case laboriouse, ploddinge, strollinge, briske, instante
    
    var value: Double {
        switch self {
        case .laboriouse: return 30.0
        case .ploddinge: return 25.0
        case .strollinge: return 10.0
        case .briske: return 3.0
        case .instante: return 0.0
        }
    }
}
enum DecimalPoint {
    case zero, one, two, ridiculous
    
    var formatString: String {
        switch self {
        case .zero: return "%.0f"
        case .one: return "%.1f"
        case .two: return "%.2f"
        case .ridiculous: return "%f"
        }
    }
}
enum CountMethod {
	case easyInOut, easyIn, easyOut, linear
}



typealias OptCallback = (() -> Void)
typealias OptFormatBlock = (() -> String)

// Animated Labels that count incrementally from two numbers
class AnimateLabel: UILabel {
	var completion: OptCallback?
	var animateDuration: AnimateDuration = .briske
	var decimalPoints: DecimalPoint = .zero
	var countingMethod: CountMethod = .easyOut
	var customFormatBlock: OptFormatBlock?

	
	fileprivate var rate: Float = 0
	fileprivate var startValue: Float = 0
	fileprivate var destinationValues: Float = 0
	fileprivate var progressValues: TimeInterval = 0
	fileprivate var updateValue: TimeInterval = 0
	fileprivate var totalTimeValue: TimeInterval = 0
	fileprivate var easingRateValue: Float = 0
	fileprivate var timerValue: CADisplayLink?
	
    fileprivate var currentValues: Float {
        if progressValues >= totalTimeValue { return destinationValues }
        return startValue + (update(t: Float(progressValues / totalTimeValue)) * (destinationValues - startValue))
    }
    
	func count(from: Float, to: Float, duration: TimeInterval? = nil) {
		startValue = from
		destinationValues = to
		timerValue?.invalidate()
		timerValue = nil
		
		if (duration == 0.0) {
			// No animation
			setValueToLabel(value: to)
			completion?()
			return
		}
		
		easingRateValue = 3.0
		progressValues = 0.0
		totalTimeValue = duration ?? animateDuration.value
		updateValue = Date.timeIntervalSinceReferenceDate
		rate = 3.0
		
		addLinkToDisplay()
	}
    func stopGame() {
        timerValue?.invalidate()
        timerValue = nil
        progressValues = totalTimeValue
        completion?()
    }
    
    func countFromZeroValue(to: Float, duration: TimeInterval? = nil) {
        count(from: 0, to: to, duration: duration ?? nil)
    }
    
	func countFromCurrentValue(to: Float, duration: TimeInterval? = nil) {
		count(from: currentValues, to: to, duration: duration ?? nil)
	}
    func copyLab( Label label: UILabel) {
        self.font = label.font
        self.highlightedTextColor = label.highlightedTextColor
        self.isEnabled = label.isEnabled
        self.isOpaque = label.isOpaque
        self.isHidden = label.isHidden
        self.isHighlighted = label.isHighlighted
        self.lineBreakMode = label.lineBreakMode
        self.numberOfLines = label.numberOfLines
        self.text = label.text
        self.textColor = label.textColor
        self.backgroundColor = label.backgroundColor
        self.frame = label.frame
        self.alpha = label.alpha
        self.tintColor = label.tintColor
        self.highlightedTextColor = label.highlightedTextColor
        self.shadowColor = label.shadowColor
        self.textAlignment = label.textAlignment
        self.addConstraints(label.constraints)
        self.center = label.center
        self.baselineAdjustment = label.baselineAdjustment
        self.attributedText = label.attributedText
        self.lineBreakMode = label.lineBreakMode
        self.transform = label.transform
        self.preferredMaxLayoutWidth = label.preferredMaxLayoutWidth
        
    }
	
	fileprivate func addLinkToDisplay() {
		timerValue = CADisplayLink(target: self, selector: #selector(self.updateValue(timerValue:)))
		timerValue?.add(to: .main, forMode: .defaultRunLoopMode)
		timerValue?.add(to: .main, forMode: .UITrackingRunLoopMode)
	}
    @objc fileprivate func updateValue(timerValue: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progressValues += now - updateValue
        updateValue = now
        
        if progressValues >= totalTimeValue {
            self.timerValue?.invalidate()
            self.timerValue = nil
            progressValues = totalTimeValue
        }
        
        setValueToLabel(value: currentValues)
        if progressValues == totalTimeValue { completion?() }
    }
    
    fileprivate func setValueToLabel(value: Float) {
        text = "$" + String(format: customFormatBlock?() ?? decimalPoints.formatString, value)
    }
	fileprivate func update(t: Float) -> Float {
		var t = t
		
		switch countingMethod {
		case .linear:
			return t
		case .easyIn:
			return powf(t, rate)
		case .easyInOut:
			var sign: Float = 1
			if Int(rate) % 2 == 0 { sign = -1 }
			t *= 2
			return t < 1 ? 0.5 * powf(t, rate) : (sign*0.5) * (powf(t-2, rate) + sign*2)
		case .easyOut:
			return 1.0-powf((1.0-t), rate);
		}
	}
}
