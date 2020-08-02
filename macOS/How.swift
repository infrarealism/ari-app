import AppKit

final class How: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 700, height: 500), styleMask:
            [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.material = .titlebar
        contentView!.addSubview(blur)
        
        let title = Label(.key("How.it.works"), .bold(2))
        contentView!.addSubview(title)
        
        let separator = Separator()
        contentView!.addSubview(separator)
        
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        separator.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        center()
        setFrameAutosaveName("How")
    }
    
    override func close() {
        NSApp.closedOther()
        super.close()
    }
}
