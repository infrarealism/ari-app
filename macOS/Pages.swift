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
        
        first.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        first.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        first.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        offset = first.leftAnchor.constraint(equalTo: effect.leftAnchor)
        offset.isActive = true
        
        second.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        second.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        second.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        second.leftAnchor.constraint(equalTo: first.rightAnchor).isActive = true
        
        third.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        third.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        third.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        third.leftAnchor.constraint(equalTo: second.rightAnchor).isActive = true
        
        fourth.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        fourth.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        fourth.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        fourth.leftAnchor.constraint(equalTo: third.rightAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        progress.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6).isActive = true
        progress.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 3).isActive = true
        progress.widthAnchor.constraint(equalToConstant: 354).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        bar.topAnchor.constraint(equalTo: progress.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: progress.leftAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
        self.progress = bar.widthAnchor.constraint(equalToConstant: 0)
        self.progress.isActive = true
    }
}
