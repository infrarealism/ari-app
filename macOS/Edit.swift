import AppKit
import Combine
import Core

class Edit<W>: NSView where W : Website {
    private(set) weak var website: W!
    private(set) weak var text: Text!
    private(set) weak var info: Blob!
    private(set) weak var scrollLeft: NSLayoutConstraint!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    required init(website: W) {
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
        
        let info = Blob(icon: "text.badge.star")
        info.target = self
        info.action = #selector(edit)
        addSubview(info)
        self.info = info
        
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
        
        info.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        info.rightAnchor.constraint(equalTo: link.leftAnchor, constant: -5).isActive = true
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: text)
            .map { ($0.object as! Text).updated }
            .debounce(for: .seconds(1.1), scheduler: DispatchQueue(label: "", qos: .utility))
            .sink(receiveValue: website.update)
            .store(in: &subs)
    }
    
    override func becomeFirstResponder() -> Bool {
        window?.makeFirstResponder(text)
        return true
    }
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2) - scrollLeft.constant
        }
    }
    
    @objc private func edit(_ button: Button) {
        _ = Info(relative: button, website: website, page: text.page)
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
