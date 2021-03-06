import UIKit

class Control: UIView {
    weak var target: AnyObject!
    var action: Selector!
    var enabled = true
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        guard enabled else { return }
        hoverOn()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with: UIEvent?) {
        hoverOff()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with: UIEvent?) {
        guard enabled else { return }
        if bounds.contains(touches.first!.location(in: self)) {
            _ = target.perform(action, with: self)
        }
        hoverOff()
    }
    
    func hoverOn() {
        
    }
    
    func hoverOff() {
        
    }
}
