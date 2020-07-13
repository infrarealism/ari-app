import AppKit

final class Link: NSPopover {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        contentSize = .init(width: 300, height: 150)
        contentViewController = .init()
        contentViewController!.view = NSView()
        behavior = .transient
    }
}
