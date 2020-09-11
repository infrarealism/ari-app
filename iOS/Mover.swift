import UIKit
import CoreServices
import Core

final class Mover: UIDocumentPickerViewController, UIDocumentPickerDelegate {
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
