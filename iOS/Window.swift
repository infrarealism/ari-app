import SwiftUI
import Core

extension UIWindow {
    func launch() {
        rootViewController = UIHostingController(rootView: Launch(window: self))
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
    
    func open(_ bookmark: Bookmark) {
        guard let website = bookmark.access.flatMap(Website.load) else {
            let alert = UIAlertController(title: .key("Bookmark.error.title"), message: .key("Bookmark.error.message"), preferredStyle: .alert)
            alert.addAction(.init(title: .key("Continue"), style: .cancel))
            rootViewController!.present(alert, animated: true)
            bookmark.access?.stopAccessingSecurityScopedResource()
            return
        }
        bookmark.access?.stopAccessingSecurityScopedResource()
        rootViewController!.dismiss(animated: false)
        rootViewController = UIHostingController(rootView: Main(window: self, website: website))
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
