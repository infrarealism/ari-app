import WebKit

final class Web: WKWebView {
    override var mouseDownCanMoveWindow: Bool { true }
    
    private weak var main: Main!
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .zero, configuration: .init())
        translatesAutoresizingMaskIntoConstraints = false
        load(.init(url: main.url.appendingPathComponent("index.html")))
    }
}
