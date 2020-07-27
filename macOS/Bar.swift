import AppKit
import Core

final class Bar: NSVisualEffectView {
    private(set) weak var edit: Control!
    private(set) weak var style: Control!
    private(set) weak var preview: Control!
    
    required init?(coder: NSCoder) { nil }
    init(website: Website) {
        super.init(frame: .zero)
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false
        material = .hudWindow
        
        let icon = NSImageView(image: NSImage(named: website.icon)!)
        icon.contentTintColor = .systemIndigo
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleProportionallyDown
        addSubview(icon)
        
        let title = Label(website.model.name, .bold())
        title.alignment = .center
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let edit = Item(icon: "hammer", title: .key("Edit"))
        addSubview(edit)
        self.edit = edit
        
        let style = Item(icon: "paintbrush", title: .key("Style"))
        addSubview(style)
        self.style = style
        
        let preview = Item(icon: "paperplane", title: .key("Preview"))
        addSubview(preview)
        self.preview = preview
        
        widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
        
        edit.bottomAnchor.constraint(equalTo: style.topAnchor, constant: -20).isActive = true
        edit.leftAnchor.constraint(equalTo: preview.leftAnchor).isActive = true
        edit.rightAnchor.constraint(equalTo: preview.rightAnchor).isActive = true
        
        style.bottomAnchor.constraint(equalTo: preview.topAnchor, constant: -20).isActive = true
        style.leftAnchor.constraint(equalTo: preview.leftAnchor).isActive = true
        style.rightAnchor.constraint(equalTo: preview.rightAnchor).isActive = true
        
        preview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        preview.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        preview.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
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
