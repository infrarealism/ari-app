import AppKit

final class Field: NSTextField {
    override var acceptsFirstResponder: Bool { true }
    override var canBecomeKeyView: Bool { true }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        bezelStyle = .roundedBezel
        font = .medium()
        maximumNumberOfLines = 1
    }
}
