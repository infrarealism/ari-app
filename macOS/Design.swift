import AppKit
import Core

final class Design: NSView {
    private weak var main: Main!
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.main = main
        
        let scroll = Scroll()
        addSubview(scroll)
        
        let link = Tint(title: .key(""))
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.right.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottom.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc
    private func link(_ circle: Circle) {
//        main.website.style.link = circle.color.color
    }
}

private final class Tint: NSView {
    private weak var title: Label!
    
    required init?(coder: NSCoder) { nil }
    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let blue = Circle(color: .blue)
        let indigo = Circle(color: .indigo)
        let purple = Circle(color: .purple)
        let pink = Circle(color: .pink)
        let orange = Circle(color: .orange)
    }
    
}

private final class Circle: Control {
    override var enabled: Bool {
        didSet {
            if enabled {
                hoverOff()
            } else {
                hoverOn()
            }
        }
    }
    
    let color: Color
    
    required init?(coder: NSCoder) { nil }
    init(color: Color) {
        self.color = color
        super.init()
        let tint = NSColor(srgbRed: color.red, green: color.green, blue: color.blue, alpha: 1)
        wantsLayer = true
        layer!.cornerRadius = 15
        layer!.backgroundColor = tint.cgColor
        layer!.borderColor = tint.cgColor
        
        widthAnchor.constraint(equalToConstant: 30).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        hoverOff()
    }
    
    override func hoverOn() {
        layer!.borderWidth = 10
        alphaValue = 1
    }
    
    override func hoverOff() {
        layer!.borderWidth = 0
        alphaValue = 0.7
    }
}
