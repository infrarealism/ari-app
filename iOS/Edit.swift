import SwiftUI
import Core
import Combine

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
    let view = UITextView()

    func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) {
        uiView.text.text = text
    }
}

private final class Coordinator: UIView, UITextViewDelegate {
    weak var text: UITextView!
    private var subs = Set<AnyCancellable>()
    private let view: TextView
    
    required init?(coder: NSCoder) { nil }
    init(view: TextView) {
        self.view = view
        super.init(frame: .zero)
        
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = .preferredFont(forTextStyle: .body)
        text.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        text.keyboardDismissMode = .interactive
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo: topAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        let bottom = text.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.isActive = true
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).sink {
            bottom.constant = -(($0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height - 70)
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.layoutIfNeeded()
            }
        }.store(in: &self.subs)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).sink { _ in
            bottom.constant = 0
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.layoutIfNeeded()
            }
        }.store(in: &self.subs)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.text = textView.text
    }
}
