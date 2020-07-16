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
        
        let items = Array(repeating: NSView(), count: 4)
        let pages = Pages(title: .key("New.website"), pages: items)
        
        let enterName = Label(.key("Enter.name"), .medium())
        items[0].addSubview(enterName)
        
        let name = Field()
        name.placeholderString = .key("Website.name")
        items[0].addSubview(name)
        self.name = name
        
        let firstNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        firstNext.target = self
        firstNext.action = #selector(next)
        items[0].addSubview(firstNext)
        
        let enterType = Label(.key("Enter.type"), .medium())
        items[1].addSubview(enterType)
        
        let singleSegment = Segment(icon: "dot.square.fill", title: .key("Single"))
        singleSegment.selected = true
        singleSegment.target = self
        singleSegment.action = #selector(single)
        items[1].addSubview(singleSegment)
        self.singleSegment = singleSegment
        
        let blogSegment = Segment(icon: "square.stack.3d.up.fill", title: .key("Blog"))
        blogSegment.target = self
        blogSegment.action = #selector(blog)
        items[1].addSubview(blogSegment)
        self.blogSegment = blogSegment
        
        let secondNext = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
        secondNext.target = self
        secondNext.action = #selector(next)
        items[1].addSubview(secondNext)
        
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
        NSApp.closeOther()
        super.close()
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
