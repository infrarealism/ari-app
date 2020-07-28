import AppKit
import Core

extension Website {
    @objc var icon: String { "" }
    
    @objc var edit: NSView {
        .init()
    }
}

extension Website.Single {
    override var icon: String  { "dot.square.fill" }
    
    override var edit: NSView {
        Edit.Single(website: self)
    }
}

extension Website.Blog {
    override var icon: String { "square.stack.3d.fill" }
    
    override var edit: NSView {
        Edit.Blog(website: self)
    }
}
