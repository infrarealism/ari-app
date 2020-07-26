import AppKit

let session = Session()

@NSApplicationMain
final class App: NSApplication, NSApplicationDelegate  {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        launch()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        session.load()
    }
}

extension NSApplication {
    func closeLaunch() {
        guard windows.count < 2 else { return }
        terminate(nil)
    }
    
    func closeOther() {
        guard windows.count < 2 else { return }
        launch()
    }
    
    @objc func launch() {
        (windows.filter { $0 is Launch }.first ?? Launch()).makeKeyAndOrderFront(nil)
    }
    
    @objc func open() {
        guard let panel = windows.compactMap({ $0 as? NSOpenPanel }).filter({ $0.allowedFileTypes == ["ari"] }).first else {
            let browse = NSOpenPanel()
            browse.message = .key("Open")
            browse.allowedFileTypes = ["ari"]
            browse.begin {
                guard $0 == .OK else { return }
                browse.url.flatMap(Bookmark.open).map {
                    session.open($0)
                    Main.open($0)
                }
            }
            windows.filter { $0 is Launch }.first?.close()
            return
        }
        panel.makeKeyAndOrderFront(nil)
    }
    
    @objc func purchases() {
        (NSApp.windows.first { $0 is Store } ?? Store()).makeKeyAndOrderFront(nil)
    }
}
