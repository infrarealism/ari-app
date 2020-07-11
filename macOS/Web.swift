import WebKit
import Combine

final class Web: NSView {
    override var mouseDownCanMoveWindow: Bool { true }
    private weak var main: Main!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.main = main
        
        let bar = NSVisualEffectView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.material = .titlebar
        addSubview(bar)
        
        let appareance = Segmented(items: [.key("Light"), .key("Dark")])
        appareance.selected.value = effectiveAppearance == NSAppearance(named: .darkAqua) ? 1 : 0
        bar.addSubview(appareance)
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        addSubview(separator)
        
        let web = WKWebView(frame: .zero, configuration: .init())
        web.translatesAutoresizingMaskIntoConstraints = false
        addSubview(web)
        
        bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        appareance.centerYAnchor.constraint(equalTo: bar.centerYAnchor, constant: -1).isActive = true
        appareance.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        appareance.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        separator.topAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        web.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        web.load(.init(url: main.url.appendingPathComponent("index.html")))
        
        appareance.selected.sink {
            web.appearance = $0 == 0 ? NSAppearance(named: .aqua) : NSAppearance(named: .darkAqua)
        }.store(in: &subs)
    }
}
