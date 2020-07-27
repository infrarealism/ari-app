import AppKit
import Combine
import Core

class Edit: NSView {
    final class Single: Edit {
        required init?(coder: NSCoder) { nil }
        required init(website: Website) {
            super.init(website: website)
            scrollLeft.constant = 20
        }
        
        override func ready(main: Main) {
            text.page = website.model.pages.first!
            super.ready(main: main)
        }
    }
    
    final class Blog: Edit {
        private weak var list: Scroll!
        
        required init?(coder: NSCoder) { nil }
        required init(website: Website) {
            super.init(website: website)
            scrollLeft.constant = 162
            
            let list = Scroll()
            list.drawsBackground = false
            addSubview(list)
            self.list = list
            
            let new = Blob(icon: "plus")
            new.target = self
            new.action = #selector(self.link)
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
        }
        
        override func ready(main: Main) {
            select(item: list.views.map { $0 as! Item }.first { $0.page.id == "index" }!)
            super.ready(main: main)
        }
        
        @objc private func select(item: Item) {
            list.views.map { $0 as! Item }.forEach {
                $0.enabled = $0 != item
            }
            text.page = item.page
        }
    }
    
    private weak var website: Website!
    private weak var text: Text!
    private weak var scrollLeft: NSLayoutConstraint!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    required init(website: Website) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.website = website
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let text = Text()
        scroll.documentView = text
        self.text = text
        
        let link = Blob(icon: "link.circle")
        link.target = self
        link.action = #selector(self.link)
        addSubview(link)

        let image = Blob(icon: "photo")
        image.target = self
        image.action = #selector(self.image)
        addSubview(image)
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollLeft = scroll.leftAnchor.constraint(equalTo: leftAnchor)
        scrollLeft.isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        link.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        link.rightAnchor.constraint(equalTo: image.leftAnchor, constant: -5).isActive = true
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: text)
            .map { ($0.object as! Text).updated }
            .debounce(for: .seconds(1.1), scheduler: DispatchQueue(label: "", qos: .utility))
            .sink(receiveValue: website.update)
            .store(in: &subs)
    }
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2) - scrollLeft.constant
        }
    }
    
    func ready(main: Main) {
        main.makeFirstResponder(text)
    }
    
    @objc private func link(_ button: Button) {
        let link = Link(relative: button, text: text.selectedText)
        link.subscription = link.sink { [weak self] in
            self?.text.insertText($0, replacementRange: self?.text.selectedRange() ?? .init())
        }
    }
    
    @objc private func image(_ button: Button) {
        let browse = NSOpenPanel()
        browse.message = .key("Add.image")
        browse.allowedFileTypes = NSImage.imageTypes
        browse.beginSheetModal(for: window!) { [weak self] in
            guard $0 == .OK, let url = browse.url, let website = self?.website else { return }
            let image = Image(relative: button, url: url, website: website)
            image.subscription = image.sink { [weak self] in
                self?.text.insertText($0, replacementRange: self?.text.selectedRange() ?? .init())
            }
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
