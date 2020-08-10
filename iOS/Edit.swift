import SwiftUI
import Core

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var id = Page.index.id
    @State private var text = ""
    
    var body: some View {
        TextView(text: $text)
    }
}

private struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        view.keyboardDismissMode = .interactive
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

private final class Coordinator: NSObject, UITextViewDelegate {
    private let view: TextView
    
    init(view: TextView) {
        self.view = view
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.text = textView.text
    }
}
