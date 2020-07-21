import AppKit

final class Bar: NSVisualEffectView {
    private(set) weak var title: Label!
    private(set) weak var edit: Control!
    private(set) weak var style: Control!
    private(set) weak var preview: Control!
    private(set) weak var export: Control!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false
        material = .hudWindow
        
        let title = Label("", .bold())
        addSubview(title)
        self.title = title
        
        let edit = Item(icon: "hammer", title: .key("Edit"))
        addSubview(edit)
        self.edit = edit
        
        let style = Item(icon: "paintbrush", title: .key("Style"))
        addSubview(style)
        self.style = style
        
        let preview = Item(icon: "paperplane", title: .key("Preview"))
        addSubview(preview)
        self.preview = preview
        
        let export = Item(icon: "square.and.arrow.up", title: .key("Export"))
        export.isHidden = true
        addSubview(export)
        self.export = export
        
        widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        edit.bottomAnchor.constraint(equalTo: style.topAnchor, constant: -20).isActive = true
        edit.leftAnchor.constraint(equalTo: export.leftAnchor).isActive = true
        edit.rightAnchor.constraint(equalTo: export.rightAnchor).isActive = true
        
        style.bottomAnchor.constraint(equalTo: preview.topAnchor, constant: -20).isActive = true
        style.leftAnchor.constraint(equalTo: export.leftAnchor).isActive = true
        style.rightAnchor.constraint(equalTo: export.rightAnchor).isActive = true
        
        preview.bottomAnchor.constraint(equalTo: export.topAnchor, constant: -20).isActive = true
        preview.leftAnchor.constraint(equalTo: export.leftAnchor).isActive = true
        preview.rightAnchor.constraint(equalTo: export.rightAnchor).isActive = true
        
        export.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        export.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        export.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    func select(control: Control) {
        subviews.compactMap { $0 as? Item }.forEach {
            $0.enabled = $0 != control
        }
    }
}

private final class Item: Control {
    override var enabled: Bool {
        didSet {
            if enabled {
                hoverOff()
            } else {
                hoverOn()
            }
        }
    }
    
    private weak var icon: NSImageView!
    private weak var label: Label!
    private weak var blur: NSVisualEffectView!
    
    required init?(coder: NSCoder) { nil }
    init(icon: String, title: String) {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 6
        
        let icon = NSImageView(image: NSImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        addSubview(icon)
        self.icon = icon
        
        let label = Label(title, .medium())
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(label)
        self.label = label
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 11).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -11).isActive = true
        hoverOff()
    }
    
    override func hoverOn() {
        label.textColor = .controlBackgroundColor
        icon.contentTintColor = .controlBackgroundColor
        layer!.backgroundColor = NSColor.labelColor.cgColor
    }
    
    override func hoverOff() {
        label.textColor = .labelColor
        icon.contentTintColor = .secondaryLabelColor
        layer!.backgroundColor = .clear
    }
}
