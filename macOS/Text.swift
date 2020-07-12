import AppKit
import Core
import Combine

final class Text: NSTextView {
    override var acceptsFirstResponder: Bool { true }
    override var mouseDownCanMoveWindow: Bool { true }
    override var canBecomeKeyView: Bool { true }
    override var isSelectable: Bool { get { true } set { } }
    override func accessibilityValue() -> String? { string }
    private weak var main: Main!
    private var subs = Set<AnyCancellable>()
    private let caret = CGFloat(4)
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 100_000), textContainer: Container())
        setAccessibilityElement(true)
        setAccessibilityRole(.textField)
        allowsUndo = true
        isRichText = false
        drawsBackground = false
        isContinuousSpellCheckingEnabled = false
        isAutomaticTextCompletionEnabled = false
        insertionPointColor = .systemBlue
        font = .monospacedSystemFont(ofSize: NSFont.systemFontSize + 5, weight: .medium)
        selectedTextAttributes = [.backgroundColor: NSColor.systemPink, .foregroundColor: NSColor.controlTextColor]
        isVerticallyResizable = true
        isHorizontallyResizable = true
        textContainerInset.width = 60
        textContainerInset.height = 80
        string = main.website.pages.first!.content
        self.main = main
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: self)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                var page = main.website.pages.first!
                page.content = self.string
                main.website.pages = [page]
                session.update(website: main.website)
        }.store(in: &subs)
        
        NotificationCenter.default.publisher(for: NSTextView.didChangeNotification, object: self)
            .debounce(for: .seconds(1.1), scheduler: DispatchQueue.global(qos: .utility))
            .sink { [weak self] _ in
                self?.main.render()
        }.store(in: &subs)
    }
    
    override final func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width = caret
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout: Bool) {
        var rect = rect
        rect.size.width += caret
        super.setNeedsDisplay(rect, avoidAdditionalLayout: avoidAdditionalLayout)
    }
    
    override func didChangeText() {
        super.didChangeText()
        layoutManager!.ensureLayout(for: textContainer!)
    }
}

private final class Container: NSTextContainer {
    private let storage = NSTextStorage()
    
    required init(coder: NSCoder) { fatalError() }
    init() {
        super.init(size: .zero)
        size.height = 100_000
        
        let layout = Layout()
        layout.delegate = layout
        layout.addTextContainer(self)
        storage.addLayoutManager(layout)
    }
}

private final class Layout: NSLayoutManager, NSLayoutManagerDelegate {
    private let padding = CGFloat(6)
    
    func layoutManager(_: NSLayoutManager, shouldSetLineFragmentRect: UnsafeMutablePointer<CGRect>,
                       lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>,
                       in: NSTextContainer, forGlyphRange: NSRange) -> Bool {
        baselineOffset.pointee = baselineOffset.pointee + padding
        shouldSetLineFragmentRect.pointee.size.height += padding + padding
        lineFragmentUsedRect.pointee.size.height += padding + padding
        return true
    }
    
    override func setExtraLineFragmentRect(_ rect: CGRect, usedRect: CGRect, textContainer: NSTextContainer) {
        var rect = rect
        var used = usedRect
        rect.size.height += padding + padding
        used.size.height += padding + padding
        super.setExtraLineFragmentRect(rect, usedRect: used, textContainer: textContainer)
    }
}
