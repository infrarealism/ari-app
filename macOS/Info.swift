import AppKit
import Core

final class Info: Pop<Void> {
    private weak var field: Field!
    private weak var website: Website!
    private weak var warning: Label!
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, website: Website, page: Page) {
        super.init(size: .init(width: 400, height: 300))
        self.website = website
        
        
        
        show(relative: relative)
    }
    
    @objc private func save() {
//        let id = field.stringValue.isEmpty ? field.placeholderString! : field.stringValue
//        website.add(id: id)
//        send(())
    }
}
