import UIKit

extension Browse {
    final class Coordinator: UIDocumentPickerViewController, UIDocumentPickerDelegate {
        private let browse: Browse
        
        required init?(coder: NSCoder) { nil }
        init(browse: Browse) {
            self.browse = browse
            super.init(documentTypes: [browse.type], in: .open)
            delegate = self
        }
        
        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            urls.first.map(browse.action)
        }
    }
}
