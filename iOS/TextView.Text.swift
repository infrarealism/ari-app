import SwiftUI
import Combine

extension TextView {
    final class Text: UIView, UITextViewDelegate {
        weak var text: UITextView!
        private var subs = Set<AnyCancellable>()
        private let view: TextView
        
        required init?(coder: NSCoder) { nil }
        init(view: TextView) {
            self.view = view
            super.init(frame: .zero)
            
            let text = _Text(frame: .zero, textContainer: Container())
            text.translatesAutoresizingMaskIntoConstraints = false
            text.typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 4, weight: .medium)
            text.font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 4, weight: .medium)
            text.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
            text.keyboardDismissMode = .interactive
            text.backgroundColor = .clear
            text.tintColor = .systemPink
            text.autocapitalizationType = .none
            text.autocorrectionType = .no
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
}

private final class _Text: UITextView {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.width += 3
        return rect
    }
}
