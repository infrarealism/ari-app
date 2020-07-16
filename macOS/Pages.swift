import AppKit

final class Pages: NSView {
    required init?(coder: NSCoder) { nil }
    init(title: String, pages: [NSView]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = Label(title, .bold(6))
        addSubview(title)
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = .init(gray: 0, alpha: 0.2)
        progress.layer!.cornerRadius = 3
        addSubview(progress)
        
        let bar = NSView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.wantsLayer = true
        bar.layer!.backgroundColor = NSColor.systemBlue.cgColor
        progress.addSubview(bar)
    }
}
