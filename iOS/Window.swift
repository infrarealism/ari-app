import SwiftUI
import Core

extension UIWindow {
    func launch() {
        if rootViewController != nil {
            transition(.fromLeft)
        }
        rootViewController = Controller(rootView: Launch(window: self))
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
        transition(.fromRight)
        rootViewController = Controller(rootView: Main(window: self, website: website))
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

private final class Controller<Content>: UIHostingController<Content> where Content : View {
    required init?(coder aDecoder: NSCoder) { nil }
    override init(rootView: Content) {
        super.init(rootView: rootView)
        view.backgroundColor = .clear
    }
}
