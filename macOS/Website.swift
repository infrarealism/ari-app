import Foundation
import Core

extension Website {
    var edit: Edit {
        editType.init(website: self)
    }
    
    @objc fileprivate var editType: Edit.Type { fatalError() }
}

extension Single {
    override var editType: Edit.Type { SingleEdit.self }
}
