import AppKit
import Core

final class Info: Pop<Void> {
    private weak var field: Field!
    private weak var website: Website!
    private weak var warning: Label!
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, website: Website, page: Page) {
        super.init(size: .init(width: 260, height: 300))
        self.website = website
        
        let title = Item(title: .key("Title"), value: page.title)
        contentViewController!.view.addSubview(title)
        
        title.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        title.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        
        show(relative: relative)
    }
    
    @objc private func save() {
//        let id = field.stringValue.isEmpty ? field.placeholderString! : field.stringValue
//        website.add(id: id)
//        send(())
    }
}

private final class Item: NSView {
    private(set) weak var field: Field!
    
    required init?(coder: NSCoder) { nil }
    init(title: String, value: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = Label(title, .bold(2))
        addSubview(title)
        
        let field = Field()
        field.stringValue = value
        addSubview(field)
        self.field = field
        
        bottomAnchor.constraint(equalTo: field.bottomAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        field.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        field.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
