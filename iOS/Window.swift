import SwiftUI
import CoreServices

extension UIWindow {
    func folder() {
        let browse = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
//        browse.popoverPresentationController?.sourceView = view
//        browse.delegate = self
//        browse.additionalLeadingNavigationBarButtonItems = [.init(barButtonSystemItem: .stop, target: self, action: #selector(back))]
//        present(browse, animated: true)
        
        rootViewController!.present(browse, animated: true)
    }
    
    func store() {
        rootViewController!.present(UIHostingController(rootView: Store()), animated: true)
    }
}
