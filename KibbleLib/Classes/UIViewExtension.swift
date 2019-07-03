import UIKit
/**
 Public extension for the UIView class for adding convenience methods and behavior
 - author: Ali H. Shah
 - date: 06/28/2019
 */
public extension UIView {
    func AddSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func RemoveAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func Shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.09
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        layer.add(animation, forKey: "position")
    }
    
    // MARK: UIGestureRecognizer Helpers:
    // Based on a concept by Logan Wright @https://gist.github.com/loganwright/3bd5fe87d499eff23d4a
    typealias TapAction = (_ tap: UITapGestureRecognizer) -> Void
    typealias LongPressAction = (_ longPress: UILongPressGestureRecognizer) -> Void

    private struct ActionHolder {
        static var TapActionHolder: [UITapGestureRecognizer: TapAction]? = [:]
        static var LongPressActionHolder: [UILongPressGestureRecognizer: LongPressAction]? = [:]
    }

    private struct Swizzler {
        private static var exchangedRemoveFromSuperview: Bool = {
            let UIViewClass: AnyClass! = NSClassFromString("UIView")
            let originalSelector = #selector(UIView.removeFromSuperview)
            let swizzleSelector = #selector(UIView.swizzled_removeFromSuperview)
            if let original: Method = class_getInstanceMethod(UIViewClass, originalSelector), let swizzle: Method = class_getInstanceMethod(UIViewClass, swizzleSelector) {
                method_exchangeImplementations(original, swizzle)
            }
            return true
        }()

        static func SwizzleRemoveFromSuperview() {
            _ = Swizzler.exchangedRemoveFromSuperview
        }
    }

    @objc fileprivate func swizzled_removeFromSuperview() {
        self.clearActionHolder()
        self.swizzled_removeFromSuperview()
    }

    private func clearActionHolder() {
        if let gestureRecos = self.gestureRecognizers {
            for reco: UIGestureRecognizer in gestureRecos as [UIGestureRecognizer] {
                if let tap = reco as? UITapGestureRecognizer {
                    ActionHolder.TapActionHolder?[tap] = nil
                } else if let longPress = reco as? UILongPressGestureRecognizer {
                    ActionHolder.LongPressActionHolder?[longPress] = nil
                }
            }
        }
    }

    func AddSingleTapRecoWith(action: TapAction?) {
        self.AddTapRecoWith(action: action)
    }

    func AddDoubleTapRecoWith(action: TapAction?) {
        self.AddTapRecoWith(numberOfTaps: 2, action: action)
    }

    func AddTapRecoWith(numberOfTaps: Int = 1, numberOfTouches: Int = 1, action: TapAction?) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.numberOfTapsRequired = numberOfTaps
        tap.numberOfTouchesRequired = numberOfTouches
        self.addGestureRecognizer(tap)
        ActionHolder.TapActionHolder?[tap] = action
        Swizzler.SwizzleRemoveFromSuperview()
    }

    @objc fileprivate func onTap(sender: UITapGestureRecognizer) {
        if let action = ActionHolder.TapActionHolder?[sender] {
            action(sender)
        }
    }

    func AddLongPressRecoWith(action: LongPressAction?) {
        self.AddLongPressRecoFor(numberOfTouches: 1, withAction: action)
    }

    func AddLongPressRecoFor(numberOfTouches: Int, withAction action: LongPressAction?) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        longPress.numberOfTouchesRequired = numberOfTouches
        self.addGestureRecognizer(longPress)
        ActionHolder.LongPressActionHolder?[longPress] = action
        Swizzler.SwizzleRemoveFromSuperview()
    }

    @objc fileprivate func onLongPress(sender: UILongPressGestureRecognizer) {
        if let action = ActionHolder.LongPressActionHolder?[sender] {
            action(sender)
        }
    }
}
