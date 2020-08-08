import UIKit

let session = Session()

@UIApplicationMain final class App: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_: UIApplication) {
        session.load()
    }
}
