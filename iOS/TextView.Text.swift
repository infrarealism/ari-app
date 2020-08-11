import SwiftUI
import Combine
import Core

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
            text.font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .regular)
            text.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
            text.keyboardDismissMode = .interactive
            text.backgroundColor = .clear
            text.tintColor = .systemPink
            text.autocapitalizationType = .none
            text.autocorrectionType = .no
            text.delegate = self
            addSubview(text)
            self.text = text
            
            let dismiss = Blob(icon: "keyboard.chevron.compact.down")
            dismiss.target = text
            dismiss.action = #selector(text.resignFirstResponder)
            dismiss.isHidden = true
            addSubview(dismiss)
            
            text.topAnchor.constraint(equalTo: topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            let bottom = text.bottomAnchor.constraint(equalTo: bottomAnchor)
            bottom.isActive = true
            
            dismiss.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: -4).isActive = true
            dismiss.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -4).isActive = true
            
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).sink { [weak self] in
                bottom.constant = -(($0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height - 70)
                dismiss.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self?.layoutIfNeeded()
                }
            }.store(in: &subs)
            
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).sink { [weak self] _ in
                bottom.constant = 0
                dismiss.isHidden = true
                UIView.animate(withDuration: 0.5) {
                    self?.layoutIfNeeded()
                }
            }.store(in: &subs)
            
            NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: text)
                .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
                .map { view.website.model.pages.first { $0.id == view.id }!.content(($0.object as! _Text).text) }
                .receive(on: DispatchQueue(label: "", qos: .utility))
                .sink(receiveValue: view.website.update)
                .store(in: &subs)
        }
    }
}

private final class _Text: UITextView {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.width += 2
        return rect
    }
}
