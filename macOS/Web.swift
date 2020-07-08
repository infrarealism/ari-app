import WebKit

final class Web: WKWebView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero, configuration: .init())
        translatesAutoresizingMaskIntoConstraints = false
        load(.init(url: URL(string: "https://www.google.com")!))
    }
}
