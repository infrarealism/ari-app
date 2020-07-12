import AppKit

final class Edit: NSView {
    private(set) weak var text: Text!
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let text = Text(main: main)
        text.setSelectedRange(.init())
        scroll.documentView = text
        self.text = text
        
        let link = Button(icon: "link.circle", color: .controlTextColor)
        link.wantsLayer = true
        link.layer!.backgroundColor = NSColor.systemBlue.cgColor
        link.layer!.cornerRadius = 20
        addSubview(link)

        let image = Button(icon: "photo", color: .controlTextColor)
        image.wantsLayer = true
        image.layer!.backgroundColor = NSColor.systemBlue.cgColor
        image.layer!.cornerRadius = 20
        addSubview(image)
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        link.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        link.rightAnchor.constraint(equalTo: image.leftAnchor, constant: -20).isActive = true
    }
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2)
        }
    }
}
