import AppKit
import Core

final class Main: NSWindow {
    private weak var bar: Bar!
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
        bar.edit.target = self
        bar.edit.action = #selector(edit)
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
        super.close()
        NSApp.closeOther()
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
    
    @objc
    private func edit() {
        let text = Text(website: website, page: website.pages.first!)
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.documentView = text
        
        select(control: bar.edit, view: scroll)
        makeFirstResponder(text)
    }
    
    @objc
    private func preview() {
        select(control: bar.preview, view: Web())
    }
    
    @objc
    private func export() {
        select(control: bar.export, view: Web())
    }
}

