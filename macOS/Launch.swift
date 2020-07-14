import AppKit
import Combine

final class Launch: NSWindow {
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
        effect.material = .menu
        contentView = effect
        
        let second = NSVisualEffectView()
        second.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(second)
        
        let separator = Separator()
        effect.addSubview(separator)
        
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
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        second.addSubview(scroll)
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        new.rightAnchor.constraint(equalTo: effect.rightAnchor, constant: -50).isActive = true
        new.topAnchor.constraint(equalTo: effect.topAnchor, constant: 60).isActive = true
        
        open.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 50).isActive = true
        open.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        
        separator.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: effect.rightAnchor, constant: -1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: second.topAnchor).isActive = true
        
        second.topAnchor.constraint(equalTo: open.bottomAnchor, constant: 20).isActive = true
        second.leftAnchor.constraint(equalTo: effect.leftAnchor).isActive = true
        second.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        second.rightAnchor.constraint(equalTo: effect.rightAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: second.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: second.leftAnchor, constant: 1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: second.bottomAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: second.rightAnchor, constant: -1).isActive = true
        scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
        
        center()
        setFrameAutosaveName("Launch")
        
        session.bookmarks.sink { [weak self] in
            guard let self = self else { return }
            var top = scroll.top
            $0.sorted { $0.edited > $1.edited }.forEach {
                let item = Item(bookmark: $0)
                item.target = self
                item.action = #selector(self.select(item:))
                scroll.add(item)
                
                if top == scroll.top {
                    item.topAnchor.constraint(equalTo: top, constant: 10).isActive = true
                } else {
                    let separator = Separator()
                    scroll.add(separator)
                    
                    separator.topAnchor.constraint(equalTo: top).isActive = true
                    separator.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
                    separator.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    
                    item.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                }
                
                item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                top = item.bottomAnchor
            }
            scroll.bottom.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
        }.store(in: &subs)
    }
    
    override func close() {
        NSApp.closeLaunch()
        super.close()
    }
    
    @objc
    private func new() {
        (NSApp.windows.first { $0 is Create } ?? Create()).makeKeyAndOrderFront(nil)
        close()
    }
    
    @objc
    private func select(item: Item) {
        item.bookmark.access.map { url in
            session.website(item.bookmark).sink { [weak self] website in
                (NSApp.windows.compactMap { $0 as? Main }.first { $0.website.id == website.id } ?? Main(url: url,  website: website)).makeKeyAndOrderFront(nil)
                self?.close()
            }.store(in: &subs)
        }
    }
}

private final class Item: Control {
    let bookmark: Bookmark
    
    required init?(coder: NSCoder) { nil }
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init()
        wantsLayer = true
        
        let location = Label(bookmark.location, .regular())
        location.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(location)
        
        bottomAnchor.constraint(equalTo: location.bottomAnchor, constant: 15).isActive = true
        
        location.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        location.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
        
        if bookmark.name.isEmpty {
            location.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        } else {
            let name = Label(bookmark.name, .bold(4))
            name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(name)
            
            name.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
            name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            name.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
            
            location.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        }
    }
    
    override func hoverOn() {
        layer!.backgroundColor = NSColor.selectedControlColor.cgColor
    }
    
    override func hoverOff() {
        layer!.backgroundColor = .clear
    }
}
