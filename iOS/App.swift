import UIKit

let session = Session()

@UIApplicationMain final class App: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_: UIApplication) {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemPink
        session.load()
    }
}
