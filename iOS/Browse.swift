import SwiftUI

struct Browse: UIViewControllerRepresentable {
    let action: (URL) -> Void
    
    func makeCoordinator() -> Coordinator {
        .init(browse: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        context.coordinator
    }
    
    func updateUIViewController(_: UIDocumentPickerViewController, context: Context) {
        
    }
}
