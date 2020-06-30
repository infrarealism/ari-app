import AppKit
import Core

final class Create: NSWindow {
    private weak var offset: NSLayoutConstraint!
    private weak var progress: NSLayoutConstraint!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 300), styleMask:
            [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let effect = NSVisualEffectView()
        effect.translatesAutoresizingMaskIntoConstraints = false
        effect.material = .hudWindow
        contentView = effect
        
        let title = Label(.key("New.website"), .bold(6))
        effect.addSubview(title)
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = .init(gray: 0, alpha: 0.2)
        progress.layer!.cornerRadius = 3
        effect.addSubview(progress)
        
        let bar = NSView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.wantsLayer = true
        bar.layer!.backgroundColor = NSColor.systemBlue.cgColor
        progress.addSubview(bar)
        
        let first = NSView()
        first.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(first)
        
        let second = NSView()
        second.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(second)
        
        let enterName = Label(.key("Enter.name"), .medium())
        first.addSubview(enterName)
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.refusesFirstResponder = true
        name.drawsBackground = false
        name.bezelStyle = .roundedBezel
        name.font = .medium()
        name.maximumNumberOfLines = 1
        name.placeholderString = .key("Website.name")
        first.addSubview(name)
        
        let firstNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        firstNext.target = self
        firstNext.action = #selector(next)
        first.addSubview(firstNext)
        
        let secondNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        secondNext.target = self
        secondNext.action = #selector(next)
        second.addSubview(secondNext)
        
        let secondPrevious = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
        secondPrevious.target = self
        secondPrevious.action = #selector(previous)
        second.addSubview(secondPrevious)
        
        first.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        first.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        first.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        offset = first.leftAnchor.constraint(equalTo: effect.leftAnchor)
        offset.isActive = true
        
        second.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        second.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        second.widthAnchor.constraint(equalTo: effect.widthAnchor).isActive = true
        second.leftAnchor.constraint(equalTo: first.rightAnchor).isActive = true
        
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
        
        enterName.topAnchor.constraint(equalTo: first.topAnchor, constant: 100).isActive = true
        enterName.leftAnchor.constraint(equalTo: first.leftAnchor, constant: 20).isActive = true
        
        name.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 20).isActive = true
        name.leftAnchor.constraint(equalTo: enterName.leftAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        firstNext.centerXAnchor.constraint(equalTo: first.centerXAnchor).isActive = true
        firstNext.bottomAnchor.constraint(equalTo: first.bottomAnchor, constant: -30).isActive = true
        
        secondNext.leftAnchor.constraint(equalTo: second.centerXAnchor, constant: 20).isActive = true
        secondNext.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
        
        secondPrevious.rightAnchor.constraint(equalTo: second.centerXAnchor, constant: -20).isActive = true
        secondPrevious.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.closeOther()
    }
    
    @objc
    private func next() {
        offset.constant -= 400
        progress.constant = -offset.constant / 1600 * 356
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }
    }
    
    @objc
    private func previous() {
        offset.constant += 400
        progress.constant = -offset.constant / 1600 * 356
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }
    }
    
    @objc
    private func open() {
        let browse = NSOpenPanel()
        browse.canChooseFiles = false
        browse.canChooseDirectories = true
        browse.begin { [weak self] in
            guard $0 == .OK, let url = browse.url else { return }
//            let bookmark = Bookmark(url)
//            balam.add(bookmark)
//            self?.select(bookmark)
        }
    }

}
