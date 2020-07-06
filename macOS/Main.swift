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
    }
    
    override func close() {
        super.close()
        NSApp.closeOther()
    }
    
    @objc
    private func edit(_ control: Control) {
        bar.select(control: control)
        contentView!.subviews.filter { !($0 is Bar) }.forEach {
            $0.removeFromSuperview()
        }
    }
    
    @objc
    private func preview(_ control: Control) {
        bar.select(control: control)
    }
    
    @objc
    private func export(_ control: Control) {
        bar.select(control: control)
    }
}

