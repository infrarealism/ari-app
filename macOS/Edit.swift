import AppKit
import Combine
import Core

final class Edit: NSView {
    private(set) weak var text: Text!
    private weak var main: Main!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(main: Main, page: Page) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.main = main
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let text = Text(page: page)
        text.setSelectedRange(.init())
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
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        link.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        link.rightAnchor.constraint(equalTo: image.leftAnchor, constant: -5).isActive = true
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: text)
            .map { ($0.object as! Text).string }
            .map(page.content)
            .debounce(for: .seconds(1.1), scheduler: DispatchQueue(label: "", qos: .utility))
            .sink(receiveValue: main.website.update)
            .store(in: &subs)
    }
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2)
        }
    }
    
    @objc private func link(_ button: Button) {
        let link = Link(relative: button)
        link.subscription = link.sink { [weak self] in
            self?.text.insertText($0, replacementRange: self?.text.selectedRange() ?? .init())
        }
    }
    
    @objc private func image(_ button: Button) {
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
