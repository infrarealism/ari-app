import AppKit

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
}

extension NSApplication {
    func launch() {
        (windows.filter { $0 is Launch }.first ?? Launch()).makeKeyAndOrderFront(nil)
    }
    
    func close() {
        guard windows.count < 2 else { return }
        terminate(nil)
    }
}
