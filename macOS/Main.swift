import AppKit
import Core

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    
    private let website: Website
    
    init(website: Website) {
        self.website = website
        super.init(contentRect: .init(x: 0, y: 0, width: 1200, height: 800), styleMask:
            [.borderless, .closable, .miniaturizable, .resizable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 600, height: 400)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false

        let bar = Bar()
        contentView!.addSubview(bar)
        
        bar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
    }
    
    override func close() {
        super.close()
        NSApp.closeOther()
    }
    
    func windowDidMove(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }
    
    func windowDidResize(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }
}

