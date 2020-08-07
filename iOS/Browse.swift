import SwiftUI
import CoreServices

struct Browse: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    func makeCoordinator() -> Coordinator {
        .init(browse: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_: UIDocumentPickerViewController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        private let browse: Browse
        
        init(browse: Browse) {
            self.browse = browse
        }
        
        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            browse.url = urls.first
        }
    }
}
