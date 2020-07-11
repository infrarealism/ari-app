import WebKit

final class Web: NSView {
    override var mouseDownCanMoveWindow: Bool { true }
    private weak var web: WKWebView!
    private weak var main: Main!
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.main = main
        
        let bar = NSVisualEffectView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.material = .titlebar
        addSubview(bar)
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        addSubview(separator)
        
        let web = WKWebView(frame: .zero, configuration: .init())
        web.translatesAutoresizingMaskIntoConstraints = false
        addSubview(web)
        self.web = web
        
        bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        separator.topAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        web.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        refresh()
    }
    
    private func refresh() {
        web.load(.init(url: main.url.appendingPathComponent("index.html")))
    }
}
