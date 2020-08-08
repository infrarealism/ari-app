import AppKit

let session = Session()

@NSApplicationMain
final class App: NSApplication, NSApplicationDelegate  {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func application(_: NSApplication, open: [URL]) {
        open.forEach(NSApp.open)
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        session.load()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        guard NSApp.windows.isEmpty else { return }
        launch()
    }
}

extension NSApplication {
    func closedLaunch() {
        guard windows.count < 2 else { return }
        terminate(nil)
    }
    
    func closedOther() {
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
            browse.begin { [weak self] in
                guard $0 == .OK, let url = browse.url else {
                    self?.launch()
                    return
                }
                self?.open(url)
            }
            windows.filter { $0 is Launch }.first?.close()
            return
        }
        panel.makeKeyAndOrderFront(nil)
    }
    
    @objc func purchases() {
        (NSApp.windows.first { $0 is Store } ?? Store()).makeKeyAndOrderFront(nil)
    }
    
    @objc func how() {
        (NSApp.windows.first { $0 is How } ?? How()).makeKeyAndOrderFront(nil)
    }
    
    fileprivate func open(_ url: URL) {
        Bookmark.open(url).map {
            session.update($0)
            Main.open($0)
        }
    }
}
