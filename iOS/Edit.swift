import SwiftUI
import Core

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    
    var body: some View {
        Circle()
    }
}

private struct TextView: UIViewRepresentable {
    @Binding var text: String
    weak var coordinator: Coordinator!

    func makeCoordinator() -> Coordinator {
        coordinator.view = self
        return coordinator
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        context.coordinator.prepare(view)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

private final class Coordinator: NSObject, UITextViewDelegate {
    var view: TextView?
    weak var textView: UITextView?
    
    func prepare(_ view: UITextView) {
        textView = view
        view.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view?.text = textView.text
    }
    
    func start() {
        textView?.becomeFirstResponder()
        textView?.selectAll(nil)
    }
}
