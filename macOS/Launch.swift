import AppKit
import Core

final class Launch: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Launch" }
    
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
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        new.rightAnchor.constraint(equalTo: effect.rightAnchor, constant: -50).isActive = true
        new.topAnchor.constraint(equalTo: effect.topAnchor, constant: 60).isActive = true
        
        open.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 50).isActive = true
        open.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
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
        Main(website: .init()).makeKeyAndOrderFront(nil)
        close()
    }
}
