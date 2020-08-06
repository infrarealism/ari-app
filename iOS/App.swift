import UIKit

let session = Session()

@UIApplicationMain final class App: NSObject, UIApplicationDelegate {
    var windows = Set<UIWindow>()
    
    func applicationDidFinishLaunching(_: UIApplication) {
        session.load()
    }
    
    func application(_: UIApplication, didDiscardSceneSessions: Set<UISceneSession>) {
        windows = windows.filter {
            !didDiscardSceneSessions.contains($0.windowScene!.session)
        }
    }
}
