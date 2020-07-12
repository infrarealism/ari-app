import AppKit
import Combine
import Core

final class Design: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = Scroll()
        addSubview(scroll)
        
        let primary = Tint(title: .key("Primary.title"), description: .key("Primary.description"))
        primary.select(color: main.website.style.primary)
        scroll.add(primary)
        
        let secondary = Tint(title: .key("Secondary.title"), description: .key("Secondary.description"))
        secondary.select(color: main.website.style.secondary)
        scroll.add(secondary)
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.right.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottom.constraint(equalTo: bottomAnchor).isActive = true
        
        primary.topAnchor.constraint(equalTo: scroll.top, constant: 30).isActive = true
        primary.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        primary.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        
        secondary.topAnchor.constraint(equalTo: primary.bottomAnchor, constant: 30).isActive = true
        secondary.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        secondary.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        
        scroll.bottom.constraint(greaterThanOrEqualTo: secondary.bottomAnchor, constant: 20).isActive = true
        
        primary.color.sink {
            main.website.style.primary = $0
            session.update(website: main.website)
            main.render()
        }.store(in: &subs)
        
        secondary.color.sink {
            main.website.style.secondary = $0
            session.update(website: main.website)
            main.render()
        }.store(in: &subs)
    }
}

private final class Tint: NSView {
    let color = PassthroughSubject<Color, Never>()
    private weak var title: Label!
    
    required init?(coder: NSCoder) { nil }
    init(title: String, description: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = Label(title, .bold(4))
        addSubview(title)
        
        let description = Label(description, .regular())
        description.textColor = .secondaryLabelColor
        addSubview(description)
        
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        addSubview(background)
        
        var left = leftAnchor
        [Color.blue, .indigo, .purple, .pink, .orange].map(Circle.init).forEach {
            $0.target = self
            $0.action = #selector(select(circle:))
            addSubview($0)
            
            $0.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
            $0.leftAnchor.constraint(equalTo: left, constant: 30).isActive = true
            left = $0.rightAnchor
        }
        
        bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 20).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        description.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        background.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 15).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func select(color: Color) {
        subviews.compactMap { $0 as? Circle }.forEach {
            $0.enabled = $0.color != color
        }
    }
    
    @objc
    private func select(circle: Circle) {
        select(color: circle.color)
        color.send(circle.color)
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
        wantsLayer = true
        layer!.cornerRadius = 20
        
        let inner = NSView()
        inner.translatesAutoresizingMaskIntoConstraints = false
        inner.wantsLayer = true
        inner.layer!.backgroundColor = color.color
        inner.layer!.cornerRadius = 12
        addSubview(inner)
        
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inner.widthAnchor.constraint(equalToConstant: 24).isActive = true
        inner.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        hoverOff()
    }
    
    override func hoverOn() {
        layer!.backgroundColor = color.color
        alphaValue = 1
    }
    
    override func hoverOff() {
        layer!.backgroundColor = .clear
        alphaValue = 0.7
    }
}

private extension Color {
    var color: CGColor {
        .init(srgbRed: .init(red), green: .init(green), blue: .init(blue), alpha: 1)
    }
}
