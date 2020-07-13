import AppKit
import Core

final class Create: NSWindow {
    private weak var offset: NSLayoutConstraint!
    private weak var progress: NSLayoutConstraint!
    private weak var name: Field!
    private weak var singleSegment: Segment!
    private weak var blogSegment: Segment!
    private weak var selectedFolder: Label!
    private weak var thirdNext: Button!
    
    private var bookmark: Bookmark? {
        didSet {
            guard bookmark != nil else { return }
            thirdNext.enabled = true
            selectedFolder.textColor = .labelColor
            selectedFolder.stringValue = bookmark!.location
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
        
        let first = NSView()
        first.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(first)
        
        let second = NSView()
        second.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(second)
        
        let third = NSView()
        third.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(third)
        
        let fourth = NSView()
        fourth.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(fourth)
        
        let enterName = Label(.key("Enter.name"), .medium())
        first.addSubview(enterName)
        
        let name = Field()
        name.placeholderString = .key("Website.name")
        first.addSubview(name)
        self.name = name
        
        let firstNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        firstNext.target = self
        firstNext.action = #selector(next)
        first.addSubview(firstNext)
        
        let enterType = Label(.key("Enter.type"), .medium())
        second.addSubview(enterType)
        
        let singleSegment = Segment(icon: "dot.square.fill", title: .key("Single"))
        singleSegment.selected = true
        singleSegment.target = self
        singleSegment.action = #selector(single)
        second.addSubview(singleSegment)
        self.singleSegment = singleSegment
        
        let blogSegment = Segment(icon: "square.stack.3d.up.fill", title: .key("Blog"))
        blogSegment.target = self
        blogSegment.action = #selector(blog)
        second.addSubview(blogSegment)
        self.blogSegment = blogSegment
        
        let secondNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        secondNext.target = self
        secondNext.action = #selector(next)
        second.addSubview(secondNext)
        
        let secondPrevious = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
        secondPrevious.target = self
        secondPrevious.action = #selector(previous)
        second.addSubview(secondPrevious)
        
        let enterLocation = Label(.key("Enter.location"), .medium())
        third.addSubview(enterLocation)
        
        let folderButton = Button(text: .key("Select.folder"), background: .systemPink, foreground: .selectedTextColor)
        folderButton.target = self
        folderButton.action = #selector(folder)
        third.addSubview(folderButton)
        
        let selectedFolder = Label(.key("None.selected"), .medium())
        selectedFolder.textColor = .secondaryLabelColor
        selectedFolder.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        third.addSubview(selectedFolder)
        self.selectedFolder = selectedFolder
        
        let thirdNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        thirdNext.target = self
        thirdNext.action = #selector(next)
        thirdNext.enabled = false
        third.addSubview(thirdNext)
        self.thirdNext = thirdNext
        
        let thirdPrevious = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
        thirdPrevious.target = self
        thirdPrevious.action = #selector(previous)
        third.addSubview(thirdPrevious)
        
        let websiteReady = Label(.key("Website.ready"), .medium())
        fourth.addSubview(websiteReady)
        
        let fourthPrevious = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
        fourthPrevious.target = self
        fourthPrevious.action = #selector(previous)
        fourth.addSubview(fourthPrevious)
        
        let finish = Button(text: .key("Finish"), background: .systemPink, foreground: .selectedTextColor)
        finish.target = self
        finish.action = #selector(self.finish)
        fourth.addSubview(finish)
        
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
        
        enterName.topAnchor.constraint(equalTo: first.topAnchor, constant: 100).isActive = true
        enterName.leftAnchor.constraint(equalTo: first.leftAnchor, constant: 20).isActive = true
        
        name.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 20).isActive = true
        name.leftAnchor.constraint(equalTo: enterName.leftAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        firstNext.centerXAnchor.constraint(equalTo: first.centerXAnchor).isActive = true
        firstNext.bottomAnchor.constraint(equalTo: first.bottomAnchor, constant: -30).isActive = true
        
        enterType.topAnchor.constraint(equalTo: second.topAnchor, constant: 100).isActive = true
        enterType.leftAnchor.constraint(equalTo: second.leftAnchor, constant: 20).isActive = true
        
        singleSegment.centerYAnchor.constraint(equalTo: second.centerYAnchor, constant: 10).isActive = true
        singleSegment.rightAnchor.constraint(equalTo: second.centerXAnchor).isActive = true
        
        blogSegment.centerYAnchor.constraint(equalTo: singleSegment.centerYAnchor).isActive = true
        blogSegment.leftAnchor.constraint(equalTo: second.centerXAnchor).isActive = true
        
        secondNext.leftAnchor.constraint(equalTo: second.centerXAnchor, constant: 20).isActive = true
        secondNext.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
        
        secondPrevious.rightAnchor.constraint(equalTo: second.centerXAnchor, constant: -20).isActive = true
        secondPrevious.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
        
        enterLocation.topAnchor.constraint(equalTo: third.topAnchor, constant: 100).isActive = true
        enterLocation.leftAnchor.constraint(equalTo: third.leftAnchor, constant: 20).isActive = true
        
        selectedFolder.centerXAnchor.constraint(equalTo: third.centerXAnchor).isActive = true
        selectedFolder.bottomAnchor.constraint(equalTo: folderButton.topAnchor, constant: -15).isActive = true
        selectedFolder.leftAnchor.constraint(greaterThanOrEqualTo: third.leftAnchor, constant: 20).isActive = true
        selectedFolder.rightAnchor.constraint(lessThanOrEqualTo: third.rightAnchor, constant: -20).isActive = true
        
        folderButton.centerXAnchor.constraint(equalTo: third.centerXAnchor).isActive = true
        folderButton.centerYAnchor.constraint(equalTo: third.centerYAnchor, constant: 40).isActive = true
        
        thirdNext.leftAnchor.constraint(equalTo: third.centerXAnchor, constant: 20).isActive = true
        thirdNext.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
        
        thirdPrevious.rightAnchor.constraint(equalTo: third.centerXAnchor, constant: -20).isActive = true
        thirdPrevious.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
        
        websiteReady.topAnchor.constraint(equalTo: fourth.topAnchor, constant: 100).isActive = true
        websiteReady.leftAnchor.constraint(equalTo: fourth.leftAnchor, constant: 20).isActive = true
        
        finish.centerXAnchor.constraint(equalTo: fourth.centerXAnchor).isActive = true
        finish.centerYAnchor.constraint(equalTo: fourth.centerYAnchor, constant: 40).isActive = true
        
        fourthPrevious.centerXAnchor.constraint(equalTo: fourth.centerXAnchor).isActive = true
        fourthPrevious.bottomAnchor.constraint(equalTo: firstNext.bottomAnchor).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.closeOther()
    }
    
    @objc
    private func finish() {
        bookmark!.name = name.stringValue
        Main(url: bookmark!.access!, website: session.create(singleSegment.selected ? .single : .blog, bookmark: bookmark!)).makeKeyAndOrderFront(nil)
        close()
    }
    
    @objc
    private func single() {
        singleSegment.selected = true
        blogSegment.selected = false
    }
    
    @objc
    private func blog() {
        blogSegment.selected = true
        singleSegment.selected = false
    }
    
    @objc
    private func next() {
        offset.constant -= 400
        progress.constant = -offset.constant / 1200 * 356
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }
    }
    
    @objc
    private func previous() {
        offset.constant += 400
        progress.constant = -offset.constant / 1200 * 356
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }
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
