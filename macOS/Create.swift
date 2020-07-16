import AppKit
import Core
import Combine

final class Create: NSWindow {
    private weak var name: Field!
    private weak var next: Button!
    private weak var _single: Segment!
    private weak var _blog: Segment!
    private weak var _folder: Label!
    private var subs = Set<AnyCancellable>()
    
    private var bookmark: Bookmark? {
        didSet {
            guard bookmark != nil else { return }
            next.enabled = true
            _folder.textColor = .labelColor
            _folder.stringValue = bookmark!.location
        }
    }
    
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
        
        let pages = Pages()
        effect.addSubview(pages)
        
        pages.page {
            let title = Label(.key("Enter.name"), .medium())
            $0.addSubview(title)
            
            let name = Field()
            name.placeholderString = .key("Website.name")
            $0.addSubview(name)
            self.name = name
            
            let next = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
            next.target = pages
            next.action = #selector(pages.next)
            $0.addSubview(next)
            
            title.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            title.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 20).isActive = true
            
            name.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
            name.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
            name.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            next.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            next.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
        }
        
        pages.page {
            let type = Label(.key("Enter.type"), .medium())
            $0.addSubview(type)
            
            let _single = Segment(icon: "dot.square.fill", title: .key("Single"))
            _single.selected = true
            _single.target = self
            _single.action = #selector(single)
            $0.addSubview(_single)
            self._single = _single
            
            let _blog = Segment(icon: "square.stack.3d.up.fill", title: .key("Blog"))
            _blog.target = self
            _blog.action = #selector(blog)
            $0.addSubview(_blog)
            self._blog = _blog
            
            let next = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
            next.target = pages
            next.action = #selector(pages.next)
            $0.addSubview(next)
            
            let previous = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
            previous.target = pages
            previous.action = #selector(pages.previous)
            $0.addSubview(previous)
            
            type.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            type.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 20).isActive = true
            
            _single.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: 10).isActive = true
            _single.rightAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            _blog.centerYAnchor.constraint(equalTo: _single.centerYAnchor).isActive = true
            _blog.leftAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            next.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 20).isActive = true
            next.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
            
            previous.rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -20).isActive = true
            previous.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
        }
        
        pages.page {
            let location = Label(.key("Enter.location"), .medium())
            $0.addSubview(location)
            
            let button = Button(text: .key("Select.folder"), background: .systemPink, foreground: .selectedTextColor)
            button.target = self
            button.action = #selector(folder)
            $0.addSubview(button)
            
            let _folder = Label(.key("None.selected"), .medium())
            _folder.textColor = .secondaryLabelColor
            _folder.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.addSubview(_folder)
            self._folder = _folder
            
            let next = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
            next.target = pages
            next.action = #selector(pages.next)
            next.enabled = false
            $0.addSubview(next)
            self.next = next
            
            let previous = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
            previous.target = pages
            previous.action = #selector(pages.previous)
            $0.addSubview(previous)
            
            location.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            location.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 20).isActive = true
            
            _folder.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            _folder.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -15).isActive = true
            _folder.leftAnchor.constraint(greaterThanOrEqualTo: $0.leftAnchor, constant: 20).isActive = true
            _folder.rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: -20).isActive = true
            
            button.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: 40).isActive = true
            
            next.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 20).isActive = true
            next.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
            
            previous.rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -20).isActive = true
            previous.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
        }
        
        pages.page {
            let ready = Label(.key("Website.ready"), .medium())
            $0.addSubview(ready)
            
            let previous = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
            previous.target = pages
            previous.action = #selector(pages.previous)
            $0.addSubview(previous)
            
            let finish = Button(text: .key("Finish"), background: .systemPink, foreground: .selectedTextColor)
            finish.target = self
            finish.action = #selector(self.finish)
            $0.addSubview(finish)
            
            ready.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            ready.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 20).isActive = true
            
            finish.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            finish.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: 40).isActive = true
            
            previous.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            previous.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -30).isActive = true
        }
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        progress.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6).isActive = true
        progress.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 3).isActive = true
        progress.widthAnchor.constraint(equalToConstant: 354).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        bar.topAnchor.constraint(equalTo: progress.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: progress.leftAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
        let width = bar.widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        pages.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        pages.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        pages.leftAnchor.constraint(equalTo: effect.leftAnchor).isActive = true
        pages.rightAnchor.constraint(equalTo: effect.rightAnchor).isActive = true
        
        pages.progress.sink {
            width.constant = progress.frame.width * $0
            NSAnimationContext.runAnimationGroup {
                $0.duration = 0.3
                $0.allowsImplicitAnimation = true
                progress.layoutSubtreeIfNeeded()
            }
        }.store(in: &subs)
    }
    
    override func close() {
        NSApp.closeOther()
        super.close()
    }
    
    @objc
    private func finish() {
        bookmark!.name = name.stringValue
        Main(url: bookmark!.access!, website: session.create(_single.selected ? .single : .blog, bookmark: bookmark!)).makeKeyAndOrderFront(nil)
        close()
    }
    
    @objc
    private func single() {
        _single.selected = true
        _blog.selected = false
    }
    
    @objc
    private func blog() {
        _blog.selected = true
        _single.selected = false
    }
    
    @objc
    private func folder() {
        let browse = NSOpenPanel()
        browse.canChooseFiles = false
        browse.canChooseDirectories = true
        browse.begin { [weak self] in
            guard $0 == .OK, let url = browse.url else { return }
            self?.bookmark = .init(url)
        }
    }
}

private final class Segment: Control {
    var selected = false {
        didSet {
            icon.contentTintColor = selected ? .systemPink : .quaternaryLabelColor
            label.textColor = selected ? .labelColor : .secondaryLabelColor
        }
    }
    
    private weak var icon: NSImageView!
    private weak var label: Label!
    
    required init?(coder: NSCoder) { nil }
    init(icon: String, title: String) {
        super.init()
        
        let icon = NSImageView(image: NSImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        icon.contentTintColor = .quaternaryLabelColor
        addSubview(icon)
        self.icon = icon
        
        let label = Label(title, .bold(-2))
        label.textColor = .secondaryLabelColor
        addSubview(label)
        self.label = label
        
        widthAnchor.constraint(equalToConstant: 75).isActive = true
        heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
