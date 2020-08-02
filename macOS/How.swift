import AppKit

final class How: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 700, height: 500), styleMask:
            [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.material = .titlebar
        contentView!.addSubview(blur)
        
        let title = Label(.key("How.it.works"), .bold(2))
        contentView!.addSubview(title)
        
        let separator = Separator()
        contentView!.addSubview(separator)
        
        let single = Item(icon: "single_lined", title: .key("Single"))
        single.target = self
        single.action = #selector(self.single(item:))
        contentView!.addSubview(single)
        
        let blog = Item(icon: "blog_lined", title: .key("Blog"))
        blog.target = self
        blog.action = #selector(self.blog(item:))
        contentView!.addSubview(blog)
        
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        separator.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        single.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30).isActive = true
        single.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        blog.topAnchor.constraint(equalTo: single.bottomAnchor, constant: 20).isActive = true
        blog.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        center()
        setFrameAutosaveName("How")
        self.single(item: single)
    }
    
    override func close() {
        NSApp.closedOther()
        super.close()
    }
    
    @objc private func select(item: Item) {
        contentView!.subviews.compactMap { $0 as? Item }.forEach {
            $0.enabled = $0 != item
        }
    }
    
    @objc private func single(item: Item) {
        select(item: item)
    }
    
    @objc private func blog(item: Item) {
        select(item: item)
    }
}

private final class Item: Control {
    override var enabled: Bool {
        didSet {
            layer!.backgroundColor = enabled ? .clear : NSColor.systemPink.cgColor
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(icon: String, title: String) {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 8
        
        let icon = NSImageView(image: NSImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentTintColor = .controlTextColor
        icon.imageScaling = .scaleNone
        addSubview(icon)
        
        let title = Label(title, .medium())
        title.textColor = .controlTextColor
        addSubview(title)
        
        widthAnchor.constraint(equalToConstant: 120).isActive = true
        heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1).isActive = true
        
        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 7).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1).isActive = true
    }
}
