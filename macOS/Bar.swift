import AppKit

final class Bar: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        material = .hudWindow
        
        widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
}
