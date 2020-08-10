import AppKit
import Core

final class Text: NSTextView {
    var id = "" {
        didSet {
            string = website.model.pages.first { $0.id == id }!.content
            setSelectedRange(.init())
            needsDisplay = true
        }
    }
    
    var updated: Page {
        website.model.pages.first { $0.id == id }!.content(string)
    }
    
    override var mouseDownCanMoveWindow: Bool { true }
    override var canBecomeKeyView: Bool { true }
    override var isSelectable: Bool { get { true } set { } }
    override func accessibilityValue() -> String? { string }
    private let website: Website
    private let caret = CGFloat(4)

    required init?(coder: NSCoder) { nil }
    init(website: Website) {
        self.website = website
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 100_000), textContainer: Container())
        setAccessibilityElement(true)
        setAccessibilityRole(.textArea)
        allowsUndo = true
        isRichText = false
        drawsBackground = false
        isContinuousSpellCheckingEnabled = true
        isAutomaticTextCompletionEnabled = false
        insertionPointColor = .systemPink
        typingAttributes[.font] = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize + 4, weight: .medium)
        font = .monospacedSystemFont(ofSize: NSFont.systemFontSize + 4, weight: .medium)
        selectedTextAttributes = [.backgroundColor: NSColor.systemPink, .foregroundColor: NSColor.controlTextColor]
        isVerticallyResizable = true
        isHorizontallyResizable = true
        textContainerInset.width = 50
        textContainerInset.height = 80
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
    
    var selectedText: String {
        string[selectedRange()]
    }
}

private extension String {
    subscript (_ range: NSRange) -> Self {
        .init(self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)])
    }
}
