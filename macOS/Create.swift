import AppKit
import Core

final class Create: NSWindow {
    private weak var firstWidth: NSLayoutConstraint!
    private weak var secondWidth: NSLayoutConstraint!
    private weak var thirdWidth: NSLayoutConstraint!
    private let width = CGFloat(400)
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: width, height: 300), styleMask:
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
        
        let first = NSView()
        first.translatesAutoresizingMaskIntoConstraints = false
        effect.addSubview(first)
        
        let title = Label(.key("New.website"), .bold(6))
        effect.addSubview(title)
     
        let enterName = Label(.key("Enter.name"), .medium())
        first.addSubview(enterName)
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.refusesFirstResponder = true
        name.drawsBackground = false
        name.bezelStyle = .roundedBezel
        name.font = .medium()
        name.maximumNumberOfLines = 1
        first.addSubview(name)
        
        first.topAnchor.constraint(equalTo: effect.topAnchor).isActive = true
        first.bottomAnchor.constraint(equalTo: effect.bottomAnchor).isActive = true
        first.leftAnchor.constraint(equalTo: effect.leftAnchor).isActive = true
        firstWidth = first.widthAnchor.constraint(equalToConstant: width)
        firstWidth.isActive = true
        
        title.topAnchor.constraint(equalTo: effect.topAnchor, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: effect.leftAnchor, constant: 20).isActive = true
        
        enterName.topAnchor.constraint(equalTo: first.topAnchor, constant: 100).isActive = true
        enterName.leftAnchor.constraint(equalTo: first.leftAnchor, constant: 20).isActive = true
        
        name.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 20).isActive = true
        name.leftAnchor.constraint(equalTo: enterName.leftAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.closeOther()
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
