import AppKit
import Core

final class Main: NSWindow {
    let website: Website
    private weak var bar: Bar!
    
    class func open(_ bookmark: Bookmark) {
        guard let access = bookmark.access else { return }
        Website.load(access).map { website in
            do {
                try website.open()
                let main = Main(website: website)
                main.makeKeyAndOrderFront(nil)
                if access.deletingLastPathComponent() != website.url {
                    website.close()
                    let alert = NSAlert()
                    alert.messageText = .key("Website.moved")
                    alert.informativeText = .key("Website.select")
                    alert.addButton(withTitle: .key("Cancel"))
                    alert.addButton(withTitle: .key("Select"))
                    alert.alertStyle = .critical
                    alert.beginSheetModal(for: main) {
                        switch $0 {
                        case .alertSecondButtonReturn:
                            let browse = NSOpenPanel()
                            browse.canChooseFiles = false
                            browse.canChooseDirectories = true
                            browse.prompt = .key("Select")
                            browse.beginSheetModal(for: main) {
                                guard $0 == .OK else { return }
                                website.update(browse.url!)
                                main.close()
                                Main.open(bookmark)
                            }
                            break
                        default:
                            main.close()
                            NSApp.launch()
                            break
                        }
                    }
                }
            } catch { }
        }
        access.stopAccessingSecurityScopedResource()
    }
    
    private init(website: Website) {
        self.website = website
        super.init(contentRect: .init(x: 0, y: 0, width: 1200, height: 800), styleMask:
            [.borderless, .closable, .miniaturizable, .resizable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 700, height: 400)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false

        let bar = Bar(website: website)
        bar.edit.target = self
        bar.edit.action = #selector(edit)
        bar.style.target = self
        bar.style.action = #selector(style)
        bar.preview.target = self
        bar.preview.action = #selector(preview)
        bar.share.target = self
        bar.share.action = #selector(share)
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
        NSApp.closedOther()
        super.close()
    }
    
    private func select(control: Control, view: NSView) {
        bar.select(control: control)
        contentView!.subviews.filter { !($0 is Bar) }.forEach {
            $0.removeFromSuperview()
        }
        contentView!.addSubview(view)
        makeFirstResponder(view)
        
        view.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 1).isActive = true
        view.leftAnchor.constraint(equalTo: bar.rightAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
    }
    
    @objc private func edit() {
        select(control: bar.edit, view: website.edit)
    }
    
    @objc private func style() {
        select(control: bar.style, view: Design(website: website))
    }
    
    @objc private func share() {
        NSWorkspace.shared.activateFileViewerSelecting([website.url!.appendingPathComponent(Page.index.file)])
    }
    
    @objc private func preview() {
        select(control: bar.preview, view: Web(website: website))
    }
}
