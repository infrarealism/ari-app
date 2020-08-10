import SwiftUI
import Core

struct TextView: UIViewRepresentable {
    weak var website: Website!
    @Binding var id: String
    let view = UITextView()

    func makeCoordinator() -> Text {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> Text {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Text, context: Context) {
        uiView.text.text = website.model.pages.first { $0.id == id }!.content
    }
}
