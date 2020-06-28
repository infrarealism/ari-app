import AppKit

final class Button: Control {
    required init?(coder: NSCoder) { nil }
    init(icon: String, color: NSColor) {
        super.init()
        
        let icon = NSImageView(image: NSImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        icon.contentTintColor = color
        addSubview(icon)
        
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    init(text: String, background: NSColor, foreground: NSColor) {
        super.init()
        wantsLayer = true
        layer!.backgroundColor = background.cgColor
        layer!.cornerRadius = 16
        
        let label = Label(text, .medium())
        label.textColor = foreground
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 32).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 25).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
    }
    
    override func hoverOn() {
        alphaValue = 0.3
    }
    
    override func hoverOff() {
        alphaValue = 1
    }
}
