import SwiftUI
import CoreServices
import Core

final class Scene: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        window = .init(windowScene: scene as! UIWindowScene)
        window!.launch()
        window!.makeKeyAndVisible()
        options.urlContexts.first.map(\.url).map(receive)
    }
    
    func scene(_ scene: UIScene, openURLContexts: Set<UIOpenURLContext>) {
        openURLContexts.first.map(\.url).map(receive)
    }
    
    private func receive(_ url: URL) {
        window!.rootViewController!.present(Picker(window: window!, url: url), animated: true)
    }
}

private final class Picker: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    private weak var window: UIWindow!
    private let url: URL
    
    required init?(coder: NSCoder) { nil }
    init(window: UIWindow, url: URL) {
        self.window = window
        self.url = url
        super.init(documentTypes: [kUTTypeFolder as String], in: .open)
        delegate = self
    }
    
    func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.first.map { selected in
            _ = selected.startAccessingSecurityScopedResource()
            let website = Website.load(url)!
            website.update(selected)
            let bookmark = Bookmark(url.deletingPathExtension().lastPathComponent, url: website.file)
            selected.stopAccessingSecurityScopedResource()
            session.add(bookmark)
            self.window.open(bookmark)
        }
    }
}
