import AppKit
import Core

final class Main: NSWindow {
    var website: Website
    private weak var bar: Bar!
    
    class func open(_ bookmark: Bookmark) {
        bookmark.access.flatMap(Website.load).map(Main.init(website:))?.makeKeyAndOrderFront(nil)
    }
    
    private init(website: Website) {
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
        bar.edit.target = self
        bar.edit.action = #selector(edit)
        bar.style.target = self
        bar.style.action = #selector(style)
        bar.preview.target = self
        bar.preview.action = #selector(preview)
        bar.export.target = self
        bar.export.action = #selector(export)
        contentView!.addSubview(bar)
        self.bar = bar
        
        bar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
        center()
        setFrameAutosaveName("Main")
        
        edit()
    }
    
    override func close() {
        contentView = nil
        website.close()
        NSApp.closeOther()
        super.close()
    }
    
    private func select(control: Control, view: NSView) {
        bar.select(control: control)
        contentView!.subviews.filter { !($0 is Bar) }.forEach {
            $0.removeFromSuperview()
        }
        contentView!.addSubview(view)
        
        view.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 1).isActive = true
        view.leftAnchor.constraint(equalTo: bar.rightAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
    }
    
    @objc private func edit() {
        let edit = Edit(main: self)
        select(control: bar.edit, view: edit)
        makeFirstResponder(edit.text)
    }
    
    @objc private func style() {
        select(control: bar.style, view: Design(main: self))
    }
    
    @objc private func preview() {
        select(control: bar.preview, view: Web(main: self))
    }
    
    @objc private func export() {
        select(control: bar.export, view: Web(main: self))
    }
}

