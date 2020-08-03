import UIKit

@UIApplicationMain final class App: NSObject, UIApplicationDelegate {
    var windows = Set<UIWindow>()
    
    func applicationDidFinishLaunching(_: UIApplication) {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemPink
    }
    
    func application(_: UIApplication, didDiscardSceneSessions: Set<UISceneSession>) {
        windows = windows.filter {
            didDiscardSceneSessions.contains($0.windowScene!.session)
        }
    }
}
