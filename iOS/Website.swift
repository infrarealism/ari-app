import Foundation
import Core

extension Website {
    @objc var icon: String { "" }
}

extension Website.Single {
    override var icon: String  { "dot.square" }
}

extension Website.Blog {
    override var icon: String { "square.stack.3d.up" }
}
