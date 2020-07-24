import AppKit
import Combine

final class Steps: NSView {
    let progress = CurrentValueSubject<CGFloat, Never>(0)
    fileprivate let bottom: CGFloat

    private weak var middle: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            middle.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(bottom: CGFloat) {
        self.bottom = bottom
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
    
    override func keyDown(with: NSEvent) {
        if with.keyCode == 36 {
            if subviews.count > subviews.firstIndex(of: middle.firstItem as! NSView)! + 1 {
                next()
            }
        } else {
            super.keyDown(with: with)
        }
    }
    
    @objc func next() {
        window!.makeFirstResponder(self)
        center(subviews.firstIndex(of: middle.firstItem as! NSView)! + 1)
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
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: pages.bottom).isActive = true
        return button
    }
    
    func previous(_ pages: Steps) -> NSView {
        let button = Button(icon: "arrow.left.circle.fill", color: .systemPink)
        button.target = pages
        button.action = #selector(pages.previous)
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: pages.bottom).isActive = true
        return button
    }
}
