import AppKit
import Combine

final class Launch: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Launch" }
    
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 400), styleMask:
            [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let effect = NSVisualEffectView()
        effect.translatesAutoresizingMaskIntoConstraints = false
        contentView = effect
        
        let title = Label(.key("New"), .bold(10))
        effect.addSubview(title)
        
        let subtitle = Label(.key("Create"), .regular(-2))
        subtitle.textColor = .secondaryLabelColor
        effect.addSubview(subtitle)
        
        let new = Button(icon: "plus.square.fill", color: .systemBlue)
        new.target = self
        new.action = #selector(self.new)
        effect.addSubview(new)
        
        let open = Label(.key("Open"), .bold(10))
        effect.addSubview(open)
        
        let scroll = Scroll()
        effect.addSubview(scroll)
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        new.rightAnchor.constraint(equalTo: effect.rightAnchor, constant: -50).isActive = true
        new.topAnchor.constraint(equalTo: effect.topAnchor, constant: 60).isActive = true
        
        open.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 50).isActive = true
        open.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: open.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: effect.rightAnchor, constant: -1).isActive = true
        scroll.right.constraint(greaterThanOrEqualTo: scroll.rightAnchor).isActive = true
        scroll.bottom.constraint(equalTo: scroll.bottomAnchor).isActive = true
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
        
        (NSApp as! App).session.bookmarks.sink {
            var left = scroll.left
            $0.sorted { $0.edited > $1.edited }.forEach {
                let item = Item(bookmark: $0)
                scroll.add(item)
                
                item.topAnchor.constraint(equalTo: scroll.top).isActive = true
                item.bottomAnchor.constraint(equalTo: scroll.bottom).isActive = true
                item.leftAnchor.constraint(equalTo: left).isActive = true
                left = item.rightAnchor
            }
            scroll.right.constraint(greaterThanOrEqualTo: left).isActive = true
        }.store(in: &subs)
    }
    
    override func close() {
        super.close()
        NSApp.closeLaunch()
    }
    
    func windowDidMove(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }
    
    @objc
    private func new() {
        Create().makeKeyAndOrderFront(nil)
        close()
    }
}

private final class Item: Control {
    let bookmark: Bookmark
    
    required init?(coder: NSCoder) { nil }
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init()
        
        let name = Label(bookmark.name, .bold())
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(name)
        
        let location = Label(bookmark.location, .regular())
        location.textColor = .secondaryLabelColor
        location.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(location)
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        name.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        
        location.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        location.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        location.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        location.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
    }
}
