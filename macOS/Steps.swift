import AppKit
import Combine

final class Steps: NSView {
    let progress = CurrentValueSubject<CGFloat, Never>(0)

    private weak var middle: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            middle.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func step(_ build: (Step) -> Void) {
        let step = Step()
        step.translatesAutoresizingMaskIntoConstraints = false
        addSubview(step)
        
        build(step)
        
        step.topAnchor.constraint(equalTo: topAnchor).isActive = true
        step.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        step.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        if let previous = subviews.filter({ $0 != step }).last {
            step.leftAnchor.constraint(equalTo: previous.rightAnchor).isActive = true
        } else {
            center(step)
        }
    }
    
    private func center(_ on: Int) {
        progress.value = .init(on) / CGFloat(subviews.count - 1)
        center(subviews[on])
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }
    }
    
    private func center(_ on: NSView) {
        middle = on.centerXAnchor.constraint(equalTo: centerXAnchor)
        middle.isActive = true
    }
    
    @objc fileprivate func next() {
        window!.makeFirstResponder(self)
        center(subviews.firstIndex(of: middle.firstItem as! NSView)! + 1)
    }
    
    @objc fileprivate func previous() {
        center(subviews.firstIndex(of: middle.firstItem as! NSView)! - 1)
    }
}

final class Step: NSView {
    func next(_ pages: Steps) -> NSView {
        let button = Button(icon: "arrow.right.circle.fill", color: .systemPink)
        button.target = pages
        button.action = #selector(pages.next)
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        return button
    }
    
    func previous(_ pages: Steps) -> NSView {
        let button = Button(icon: "arrow.left.circle.fill", color: .systemPink)
        button.target = pages
        button.action = #selector(pages.previous)
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        return button
    }
}
