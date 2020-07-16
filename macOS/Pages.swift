import AppKit
import Combine

final class Pages: NSView {
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
    
    func page(_ build: (NSView) -> Void) {
        let page = NSView()
        page.translatesAutoresizingMaskIntoConstraints = false
        addSubview(page)
        
        build(page)
        
        page.topAnchor.constraint(equalTo: topAnchor).isActive = true
        page.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        page.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        if let previous = subviews.last {
            page.leftAnchor.constraint(equalTo: previous.rightAnchor).isActive = true
        } else {
            center(page)
        }
    }
    
    @objc
    func next() {
        center(subviews.firstIndex(of: middle.firstItem as! NSView)! + 1)
    }
    
    @objc
    func previous() {
        center(subviews.firstIndex(of: middle.firstItem as! NSView)! - 1)
    }
    
    private func center(_ on: Int) {
        progress.value = .init(on) / CGFloat(subviews.count)
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
}
