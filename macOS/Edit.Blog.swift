import AppKit
import Core

extension Edit {
    final class Blog: Edit<Website.Blog> {
        private weak var list: Scroll!
        private weak var trash: Blob!
                
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
            
            let trash = Blob(icon: "trash")
            trash.target = self
            trash.action = #selector(delete)
            addSubview(trash)
            self.trash = trash
            
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
            
            trash.topAnchor.constraint(equalTo: info.topAnchor).isActive = true
            trash.rightAnchor.constraint(equalTo: info.leftAnchor, constant: -5).isActive = true
            
            refresh()
            select(page: .index, scroll: false)
        }
        
        private func refresh() {
            var top = list.top
            list.views.forEach { $0.removeFromSuperview() }
            website.model.pages.sorted { $0.created < $1.created }.map { Item(id: $0.id) }.forEach {
                $0.target = self
                $0.action = #selector(select(item:))
                list.add($0)
                
                $0.topAnchor.constraint(equalTo: top, constant: top == list.top ? 100 : 0).isActive = true
                $0.leftAnchor.constraint(equalTo: list.left).isActive = true
                $0.rightAnchor.constraint(equalTo: list.right).isActive = true
                top = $0.bottomAnchor
            }
            list.bottom.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
        }
        
        private func select(page: Page, scroll: Bool) {
            let item = list.views.map { $0 as! Item }.first { $0.id == page.id }!
            select(item: item)
            if scroll {
                list.layoutSubtreeIfNeeded()
                list.center(item.frame, duration: 0.4)
            }
        }
        
        @objc private func select(item: Item) {
            list.views.map { $0 as! Item }.forEach {
                $0.enabled = $0 != item
            }
            text.id = item.id
            trash.isHidden = item.id == Page.index.id
            window?.makeFirstResponder(text)
        }
        
        @objc private func create(_ button: Button) {
            let name = Name(relative: button, website: website)
            name.subscription = name.sink { [weak self] in
                self?.refresh()
                self?.website.model.pages.sorted { $0.created > $1.created }.first.map {
                    self?.select(page: $0, scroll: true)
                }
            }
       }
        
        @objc private func delete() {
            let alert = NSAlert()
            alert.messageText = .key("Delete.page")
            alert.informativeText = .key("Cant.undo")
            alert.addButton(withTitle: .key("Cancel"))
            alert.addButton(withTitle: .key("Delete"))
            alert.alertStyle = .informational
            alert.beginSheetModal(for: window!) { [weak self] in
                guard let self = self, $0 == .alertSecondButtonReturn else { return }
                self.website.remove(self.website.model.pages.first { $0.id == self.text.id }!)
                self.refresh()
                self.select(page: .index, scroll: true)
            }
        }
    }
}

private final class Item: Control {
    let id: String
    override var enabled: Bool {
        didSet {
            layer!.backgroundColor = enabled ? .clear : NSColor.controlLightHighlightColor.cgColor
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(id: String) {
        self.id = id
        super.init()
        wantsLayer = true
        
        let label = Label(id, .medium())
        label.maximumNumberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
    }
}
