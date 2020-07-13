import AppKit

final class Field: NSTextField {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        refusesFirstResponder = true
        drawsBackground = false
        bezelStyle = .roundedBezel
        font = .medium()
        maximumNumberOfLines = 1
    }
}
