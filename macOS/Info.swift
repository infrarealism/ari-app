import AppKit
import Core

final class Info: Pop<Void> {
    private weak var website: Website!
    private weak var warning: Label!
    private var page: Page
    private var items = [Item]()
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, website: Website, page: Page) {
        self.page = page
        super.init(size: .init(width: 340, height: 380))
        self.website = website
        
        let header = Label(.key("Page.details"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let save = Button(text: .key("Save"), background: .systemPink, foreground: .controlTextColor)
        save.target = self
        save.action = #selector(self.save)
        contentViewController!.view.addSubview(save)
        
        var top = header.bottomAnchor
        items = [
            Item(title: .key("Title"), value: page.title),
            .init(title: .key("Description"), value: page.description),
            .init(title: .key("Keywords"), value: page.keywords),
            .init(title: .key("Author"), value: page.author),
        ].map {
            contentViewController!.view.addSubview($0)
            $0.topAnchor.constraint(equalTo: top, constant: top == header.bottomAnchor ? 20 : 0).isActive = true
            $0.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            top = $0.bottomAnchor
            return $0
        }
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        save.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        save.bottomAnchor.constraint(equalTo: _cancel.topAnchor, constant: -15).isActive = true
        
        show(relative: relative)
    }
    
    @objc private func save() {
        page.title = items[0].field.stringValue
        page.description = items[1].field.stringValue
        page.keywords = items[2].field.stringValue
        page.author = items[3].field.stringValue
        website.update(page)
        send(())
    }
}

private final class Item: NSView {
    private(set) weak var field: Field!
    
    required init?(coder: NSCoder) { nil }
    init(title: String, value: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = Label(title, .bold())
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let field = Field()
        field.stringValue = value
        addSubview(field)
        self.field = field
        
        bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 15).isActive = true
        widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: field.leftAnchor, constant: -2).isActive = true
        
        field.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 170).isActive = true
        field.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
