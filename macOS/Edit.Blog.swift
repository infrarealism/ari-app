import AppKit
import Core

extension Edit {
    final class Blog: Edit<Website.Blog> {
        private weak var list: Scroll!
                
        required init?(coder: NSCoder) { nil }
        required init(website: Website.Blog) {
            super.init(website: website)
            scrollLeft.constant = 162

            let list = Scroll()
            list.drawsBackground = false
            addSubview(list)
            self.list = list
            
            let new = Blob(icon: "plus")
            new.target = self
            new.action = #selector(create)
            addSubview(new)
            
            let separator = NSView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.wantsLayer = true
            separator.layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
            addSubview(separator)
            
            list.topAnchor.constraint(equalTo: topAnchor).isActive = true
            list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            list.widthAnchor.constraint(equalToConstant: 150).isActive = true
            list.width.constraint(equalTo: list.widthAnchor).isActive = true
            
            new.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            new.centerXAnchor.constraint(equalTo: list.centerXAnchor).isActive = true
            
            separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
            separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            separator.leftAnchor.constraint(equalTo: list.rightAnchor).isActive = true
            separator.widthAnchor.constraint(equalToConstant: 2).isActive = true
            
            var top = list.top
            website.model.pages.map(Item.init).forEach {
                $0.target = self
                $0.action = #selector(select(item:))
                list.add($0)
                
                $0.topAnchor.constraint(equalTo: top, constant: top == list.top ? 100 : 0).isActive = true
                $0.leftAnchor.constraint(equalTo: list.left).isActive = true
                $0.rightAnchor.constraint(equalTo: list.right).isActive = true
                top = $0.bottomAnchor
            }
            list.bottom.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
            
            select(item: list.views.map { $0 as! Item }.first { $0.page.id == "index" }!)
        }
        
        @objc private func select(item: Item) {
            list.views.map { $0 as! Item }.forEach {
                $0.enabled = $0 != item
            }
            text.page = item.page
        }
        
        @objc private func create(_ button: Button) {
            Name(website: website).show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
       }
    }
}

private final class Item: Control {
    let page: Page
    override var enabled: Bool {
        didSet {
            layer!.backgroundColor = enabled ? .clear : NSColor.controlLightHighlightColor.cgColor
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(page: Page) {
        self.page = page
        super.init()
        wantsLayer = true
        
        let label = Label(page.id, .medium())
        label.maximumNumberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
    }
}
