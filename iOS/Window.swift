import SwiftUI
import Core

extension UIWindow {
    func launch() {
        transition(UIHostingController(rootView: Launch(window: self)))
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
        transition(UIHostingController(rootView: Main(window: self, website: website)))
    }
    
    private func transition(_ controller: UIViewController) {
        let snap = snapshotView(afterScreenUpdates: true)!
        controller.view.layer.opacity = 0
        controller.view.addSubview(snap)
        rootViewController = controller

        UIView.animate(withDuration: 0.5, animations: {
            controller.view.layer.opacity = 1
            snap.layer.transform = CATransform3DMakeTranslation(0, snap.bounds.height, 0)
//            snap.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { _ in
            snap.removeFromSuperview();
        }
    }
}
