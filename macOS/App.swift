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
    
    @objc
    func launch() {
        (windows.filter { $0 is Launch }.first ?? Launch()).makeKeyAndOrderFront(nil)
    }
}
