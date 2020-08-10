import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    let view = UITextView()

    func makeCoordinator() -> Text {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> Text {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Text, context: Context) {
        uiView.text.text = text
    }
}
