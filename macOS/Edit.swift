import AppKit
import Combine

final class Edit: NSView {
    private(set) weak var text: Text!
    private weak var main: Main!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.main = main
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let text = Text(main: main)
        text.setSelectedRange(.init())
        scroll.documentView = text
        self.text = text
        
        let link = Button(icon: "link.circle", color: .controlTextColor)
        link.target = self
        link.action = #selector(self.link)
        link.wantsLayer = true
        link.layer!.backgroundColor = NSColor.systemBlue.cgColor
        link.layer!.cornerRadius = 20
        addSubview(link)

        let image = Button(icon: "photo", color: .controlTextColor)
        image.target = self
        image.action = #selector(self.image)
        image.wantsLayer = true
        image.layer!.backgroundColor = NSColor.systemBlue.cgColor
        image.layer!.cornerRadius = 20
        addSubview(image)
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        link.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        link.rightAnchor.constraint(equalTo: image.leftAnchor, constant: -20).isActive = true
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: text)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { _ in
                var page = main.website.pages.first!
                page.content = text.string
                main.website.pages = [page]
                session.update(website: main.website)
        }.store(in: &subs)
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: text)
            .debounce(for: .seconds(1.1), scheduler: DispatchQueue.global(qos: .utility))
            .sink { _ in
                main.render()
        }.store(in: &subs)
    }
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2)
        }
    }
    
    @objc
    private func link(_ button: Button) {
        let link = Link(relative: button)
        link.subscription = link.sink { [weak self] in
            self?.text.insertText($0, replacementRange: self?.text.selectedRange() ?? .init())
        }
    }
    
    @objc
    private func image(_ button: Button) {
        let browse = NSOpenPanel()
        browse.message = .key("Add.image")
        browse.allowedFileTypes = NSImage.imageTypes
        browse.beginSheetModal(for: main) { [weak self] in
            guard $0 == .OK, let url = browse.url, let main = self?.main else { return }
            let image = Image(relative: button, url: url, main: main)
            image.subscription = image.sink { [weak self] in
                self?.text.insertText($0, replacementRange: self?.text.selectedRange() ?? .init())
            }
        }
    }
}
