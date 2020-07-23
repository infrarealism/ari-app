import AppKit
import Core
import Combine

final class Create: NSWindow {
    private weak var name: Field!
    private weak var _finish: Button!
    private weak var _single: Segment!
    private weak var _blog: Segment!
    private weak var _folder: Label!
    private var url: URL!
    private var subs = Set<AnyCancellable>()
    
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
        bar.layer!.backgroundColor = NSColor.systemPink.cgColor
        progress.addSubview(bar)
        
        let pages = Pages()
        effect.addSubview(pages)
        
        pages.page {
            $0.title(.key("Enter.name"))
            
            let name = Field()
            name.placeholderString = .key("Website.name")
            $0.addSubview(name)
            self.name = name
            
            $0.addNext(pages).centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            name.topAnchor.constraint(equalTo: $0.topAnchor, constant: 140).isActive = true
            name.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            name.widthAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        pages.page {
            $0.title(.key("Enter.type"))

            let _single = Segment(icon: "dot.square", title: .key("Single"))
            _single.selected = true
            _single.target = self
            _single.action = #selector(single)
            $0.addSubview(_single)
            self._single = _single

            let _blog = Segment(icon: "square.stack.3d.up", title: .key("Blog"))
            _blog.target = self
            _blog.action = #selector(blog)
            $0.addSubview(_blog)
            self._blog = _blog
            
            let purchase = NSView()
            purchase.translatesAutoresizingMaskIntoConstraints = false
            purchase.wantsLayer = true
            purchase.layer!.backgroundColor = NSColor.systemIndigo.cgColor
            purchase.layer!.cornerRadius = 11
            $0.addSubview(purchase)
            
            let _purchase = Label(.key("In.app"), .regular(-2))
            _purchase.textColor = .controlTextColor
            purchase.addSubview(_purchase)

            $0.addPrevious(pages).rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -20).isActive = true
            $0.addNext(pages).leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 20).isActive = true
            
            _single.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: 10).isActive = true
            _single.rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -30).isActive = true

            _blog.centerYAnchor.constraint(equalTo: _single.centerYAnchor).isActive = true
            _blog.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 30).isActive = true

            purchase.topAnchor.constraint(equalTo: _blog.bottomAnchor, constant: -25).isActive = true
            purchase.centerXAnchor.constraint(equalTo: _blog.centerXAnchor).isActive = true
            purchase.rightAnchor.constraint(equalTo: _purchase.rightAnchor, constant: 8).isActive = true
            purchase.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            _purchase.leftAnchor.constraint(equalTo: purchase.leftAnchor, constant: 8).isActive = true
            _purchase.centerYAnchor.constraint(equalTo: purchase.centerYAnchor).isActive = true
            
            session.user.sink {
                purchase.isHidden = $0.purchases.contains(.blog)
            }.store(in: &subs)
        }
        
        pages.page {
            $0.title(.key("Enter.location"))
            
            let button = Button(text: .key("Select.folder"), background: .systemPink, foreground: .selectedTextColor)
            button.target = self
            button.action = #selector(folder)
            $0.addSubview(button)
            
            let _folder = Label(.key("None.selected"), .medium())
            _folder.textColor = .secondaryLabelColor
            _folder.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.addSubview(_folder)
            self._folder = _folder
            
            let _finish = Button(text: .key("Finish"), background: .systemPink, foreground: .selectedTextColor)
            _finish.target = self
            _finish.action = #selector(finish)
            _finish.enabled = false
            $0.addSubview(_finish)
            self._finish = _finish
            
            $0.addPrevious(pages).rightAnchor.constraint(equalTo: _finish.leftAnchor, constant: -40).isActive = true
            
            _folder.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            _folder.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -15).isActive = true
            _folder.leftAnchor.constraint(greaterThanOrEqualTo: $0.leftAnchor, constant: 20).isActive = true
            _folder.rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: -20).isActive = true
            
            button.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: $0.centerYAnchor, constant: 40).isActive = true
            
            _finish.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            _finish.centerYAnchor.constraint(equalTo: $0.bottomAnchor, constant: -50).isActive = true
        }
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 30).isActive = true
        title.centerXAnchor.constraint(equalTo: effect.centerXAnchor).isActive = true
        
        progress.topAnchor.constraint(equalTo: effect.topAnchor, constant: 84).isActive = true
        progress.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 23).isActive = true
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
    
    @objc private func finish() {
        let bookmark = Bookmark(name.stringValue, url: _single.selected
            ? Website.single(name.stringValue, directory: url!)
            : Website.blog(name.stringValue, directory: url!))
        session.add(bookmark)
        Main.open(bookmark)
        close()
    }
    
    @objc private func single() {
        _single.selected = true
        _blog.selected = false
    }
    
    @objc private func blog() {
        if session.user.value.purchases.contains(.blog) {
            _blog.selected = true
            _single.selected = false
        } else {
            NSApp.purchases()
        }
    }
    
    @objc private func folder() {
        let browse = NSOpenPanel()
        browse.canChooseFiles = false
        browse.canChooseDirectories = true
        browse.beginSheetModal(for: self) { [weak self] in
            guard $0 == .OK else { return }
            self?.url = browse.url
            self?._finish.enabled = true
            self?._folder.textColor = .labelColor
            self?._folder.stringValue = browse.url!.directory ?? browse.url!.path
        }
    }
}

private final class Segment: Control {
    var selected = false {
        didSet {
            icon.contentTintColor = selected ? .systemPink : .disabledControlTextColor
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
        icon.contentTintColor = .disabledControlTextColor
        addSubview(icon)
        self.icon = icon
        
        let label = Label(title, .bold(-2))
        label.textColor = .secondaryLabelColor
        addSubview(label)
        self.label = label
        
        widthAnchor.constraint(equalToConstant: 110).isActive = true
        heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
    }
}

private extension NSView {
    func title(_ text: String) {
        let label = Label(text, .regular())
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 62).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 21).isActive = true
    }
    
    func addNext(_ pages: Pages) -> NSView {
        let button = Button(icon: "arrow.right.circle.fill", color: .systemPink)
        button.target = pages
        button.action = #selector(pages.next)
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        return button
    }
    
    func addPrevious(_ pages: Pages) -> NSView {
        let button = Button(icon: "arrow.left.circle.fill", color: .systemPink)
        button.target = pages
        button.action = #selector(pages.previous)
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        return button
    }
}
