import WebKit
import Core
import Combine

final class Web: NSView {
    override var mouseDownCanMoveWindow: Bool { true }
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(website: Website) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let appeareance = Segmented(items: [.key("Light"), .key("Dark")])
        appeareance.selected.value = effectiveAppearance == NSAppearance(named: .darkAqua) ? 1 : 0
        addSubview(appeareance)
        
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        addSubview(separator)
        
        let web = WKWebView(frame: .zero, configuration: .init())
        web.translatesAutoresizingMaskIntoConstraints = false
        addSubview(web)
        
        appeareance.centerYAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        appeareance.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        appeareance.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        web.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        web.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        web.load(.init(url: website.url!.appendingPathComponent(Page.index.file)))
        
        appeareance.selected.sink {
            web.appearance = $0 == 0 ? NSAppearance(named: .aqua) : NSAppearance(named: .darkAqua)
        }.store(in: &subs)
    }
}
