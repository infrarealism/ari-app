import Foundation
import Core

extension Website {
    @objc var icon: String { "" }
    
    var edit: Edit {
        editType.init(website: self)
    }
    
    @objc fileprivate var editType: Edit.Type { Edit.self }
}

extension Website.Single {
    override var icon: String  { "dot.square.fill" }
    override var editType: Edit.Type { Edit.Single.self }
}

extension Website.Blog {
    override var icon: String { "square.stack.3d.fill" }
    override var editType: Edit.Type { Edit.Blog.self }
}
