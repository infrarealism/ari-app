import AppKit
import Core
import Combine

final class Image: Pop<String>, NSTextFieldDelegate {
    private weak var duplicate: NSSwitch!
    private weak var name: Label!
    private weak var segmented: Segmented!
    private weak var field: Field!
    private weak var website: Website!
    private var subs = Set<AnyCancellable>()
    private let images: [NSImage]
    private let url: URL
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, url: URL, website: Website) {
        self.url = url
        images = NSImage(contentsOf: url)!.scales([0.25, 0.5])
        super.init(size: .init(width: 380, height: 380))
        show(relative: relative)
        self.website = website
        
        let header = Label(.key("Add.image"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        let steps = Steps(bottom: -70)
        contentViewController!.view.addSubview(steps)
        
        steps.step {
            let snipped = NSImageView(image: images.last!)
            snipped.translatesAutoresizingMaskIntoConstraints = false
            snipped.imageScaling = .scaleProportionallyUpOrDown
            snipped.wantsLayer = true
            snipped.layer!.backgroundColor = .black
            $0.addSubview(snipped)
            
            let name = Label(url.lastPathComponent, .medium(-2))
            name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.addSubview(name)
            self.name = name
            
            let _duplicate = Label(.key("Duplicate"), .regular())
            _duplicate.textColor = .secondaryLabelColor
            $0.addSubview(_duplicate)
            
            let duplicate = NSSwitch()
            duplicate.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(duplicate)
            self.duplicate = duplicate
            
            if url.absoluteString.hasPrefix(website.url!.absoluteString) {
                _duplicate.isHidden = true
                duplicate.isHidden = true
            } else {
                duplicate.state = .on
            }
            
            $0.next(steps).centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            snipped.topAnchor.constraint(equalTo: $0.topAnchor, constant: 60).isActive = true
            snipped.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            snipped.widthAnchor.constraint(equalToConstant: 320).isActive = true
            snipped.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            name.topAnchor.constraint(equalTo: snipped.bottomAnchor, constant: 10).isActive = true
            name.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            name.leftAnchor.constraint(greaterThanOrEqualTo: $0.leftAnchor, constant: 30).isActive = true
            name.rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: -30).isActive = true
            
            _duplicate.rightAnchor.constraint(equalTo: duplicate.leftAnchor, constant: -10).isActive = true
            _duplicate.centerYAnchor.constraint(equalTo: duplicate.centerYAnchor).isActive = true
            
            duplicate.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30).isActive = true
            duplicate.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 80).isActive = true
        }
        
        steps.step {
            let title = Label(.key("Scale"), .medium(2))
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.addSubview(title)
            
            let segmented = Segmented(items: ["25%", "50%", "100%"])
            segmented.selected.value = 2
            $0.addSubview(segmented)
            self.segmented = segmented
            
            let scale = Label(.key(""), .medium(2))
            scale.textColor = .secondaryLabelColor
            scale.alignment = .center
            $0.addSubview(scale)
            
            let original = Label(.key("Edit.original"), .regular())
            original.textColor = .secondaryLabelColor
            $0.addSubview(original)
            
            $0.previous(steps).rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -20).isActive = true
            $0.next(steps).leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 20).isActive = true
            
            title.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            title.topAnchor.constraint(equalTo: $0.topAnchor, constant: 80).isActive = true
            
            segmented.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
            segmented.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 40).isActive = true
            segmented.rightAnchor.constraint(equalTo: $0.rightAnchor, constant: -40).isActive = true
            
            scale.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 20).isActive = true
            scale.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            original.topAnchor.constraint(equalTo: scale.bottomAnchor, constant: 10).isActive = true
            original.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            original.leftAnchor.constraint(greaterThanOrEqualTo: $0.leftAnchor, constant: 30).isActive = true
            original.rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: -30).isActive = true
            
            let bytes = ByteCountFormatter()
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            segmented.selected.sink { [weak self] in
                guard let self = self else { return }
                original.isHidden = self.duplicate.state != .off || (self.duplicate.state == .off && $0 == 2)
                let image = self.images[$0]
                scale.stringValue = formatter.string(from: .init(value: Int(image.size.width)))! + "×" + formatter.string(from: .init(value: Int(image.size.height)))! + "\n" + bytes.string(fromByteCount: .init(image.data.count))
            }.store(in: &self.subs)
        }
        
        steps.step {
            let title = Label(.key("Image.alt"), .medium(2))
            title.textColor = .secondaryLabelColor
            $0.addSubview(title)
            
            let field = Field()
            field.delegate = self
            $0.addSubview(field)
            self.field = field
            
            let add = Button(text: .key("Add"), background: .systemPink, foreground: .controlTextColor)
            add.target = self
            add.action = #selector(submit)
            $0.addSubview(add)
            
            $0.previous(steps).rightAnchor.constraint(equalTo: add.leftAnchor, constant: -40).isActive = true
            
            title.topAnchor.constraint(equalTo: $0.topAnchor, constant: 80).isActive = true
            title.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            field.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
            field.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            field.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            add.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            add.centerYAnchor.constraint(equalTo: $0.bottomAnchor, constant: -90).isActive = true
        }
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        
        steps.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor).isActive = true
        steps.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor).isActive = true
        steps.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor).isActive = true
        steps.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor).isActive = true
    }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        switch doCommandBy {
        case #selector(insertNewline):
            contentViewController!.view.window!.makeFirstResponder(contentViewController!.view)
            submit()
        case #selector(cancelOperation):
            contentViewController!.view.window!.makeFirstResponder(contentViewController!.view)
        default: return false
        }
        return true
    }
    
    @objc private func submit() {
        if duplicate.state == .on {
            images[segmented.selected.value].write(website.url!.appendingPathComponent(url.lastPathComponent))
            send(url: url.lastPathComponent)
        } else if url.absoluteString.hasPrefix(website.url!.absoluteString) {
            if segmented.selected.value != 2 {
                images[segmented.selected.value].write(url)
            }
            send(url: .init(url.absoluteString.dropFirst(website.url!.absoluteString.count)))
        } else {
            if segmented.selected.value != 2 {
                images[segmented.selected.value].write(url)
            }
            send(url: url.relativeString)
        }
    }
    
    private func send(url: String) {
        send("![\(field.stringValue)](\(url))")
    }
}

private extension NSImage {
    var data: Data {
        NSBitmapImageRep(data: tiffRepresentation!)!.representation(using: .png, properties: [:])!
    }
    
    func write(_ to: URL) {
        try! data.write(to: to, options: .atomic)
    }
    
    func scales(_ scales: [CGFloat]) -> [NSImage] {
        scales.map {
            let image = NSImage(size: .init(width: size.width * $0, height: size.height * $0))
            image.lockFocus()
            draw(in: .init(origin: .zero, size: image.size))
            image.unlockFocus()
            return image
        } + [self]
    }
}
