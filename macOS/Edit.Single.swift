import AppKit
import Core

extension Edit {
    final class Single: Edit<Website.Single> {
        required init?(coder: NSCoder) { nil }
        required init(website: Website.Single) {
            super.init(website: website)
            scrollLeft.constant = 20
            text.id = Page.index.id
        }
    }
}
