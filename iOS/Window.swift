import SwiftUI
import Core

extension UIWindow {
    func launch() {
        if rootViewController != nil {
            transition(.fromLeft)
        }
        rootViewController = UIHostingController(rootView: Launch(window: self))
    }
    
    func open(_ bookmark: Bookmark) {
        guard let access = bookmark.access else { return }
        guard let website = Website.load(access) else {
            let alert = UIAlertController(title: .key("Bookmark.error.title"), message: .key("Bookmark.error.message"), preferredStyle: .alert)
            alert.addAction(.init(title: .key("Continue"), style: .cancel))
            rootViewController!.present(alert, animated: true)
            access.stopAccessingSecurityScopedResource()
            return
        }
        try! website.open()
        rootViewController!.dismiss(animated: false)
        transition(.fromRight)
        rootViewController = UIHostingController(rootView: Main(window: self, website: website))
        access.stopAccessingSecurityScopedResource()
    }
    
    func share(_ urls: [URL]) {
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = rootViewController?.view
        rootViewController!.present(controller, animated: true)
    }
    
    private func transition(_ type: CATransitionSubtype) {
        layer.add({
            $0.duration = 0.4
            $0.type = .moveIn
            $0.subtype = type
            return $0
        } (CATransition()), forKey: kCATransition)
    }
}
