import AppKit
import Combine

final class Image: Pop {
    private weak var duplicate: NSSwitch!
    private weak var name: Label!
    private weak var segmented: Segmented!
    private weak var field: Field!
    private weak var main: Main!
    private var subs = Set<AnyCancellable>()
    private let images: [NSImage]
    private let url: URL
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, url: URL, main: Main) {
        self.url = url
        self.main = main
        images = NSImage(contentsOf: url)!.scales([0.25, 0.5])
        super.init(size: .init(width: 380, height: 380))
        show(relative: relative)
        
        let header = Label(.key("Add.image"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        let pages = Pages()
        contentViewController!.view.addSubview(pages)
        
        pages.page {
            let snipped = NSImageView(image: images.last!)
            snipped.translatesAutoresizingMaskIntoConstraints = false
            snipped.imageScaling = .scaleProportionallyDown
            $0.addSubview(snipped)
            
            let name = Label(url.lastPathComponent, .medium(-2))
            name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.addSubview(name)
            self.name = name
            
            let next = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
            next.target = pages
            next.action = #selector(pages.next)
            $0.addSubview(next)
            
            let _duplicate = Label(.key("Duplicate"), .regular())
            _duplicate.textColor = .secondaryLabelColor
            $0.addSubview(_duplicate)
            
            let duplicate = NSSwitch()
            duplicate.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(duplicate)
            self.duplicate = duplicate
            
            if url.absoluteString.hasPrefix(main.url.absoluteString) {
                _duplicate.isHidden = true
                duplicate.isHidden = true
            } else {
                duplicate.state = .on
            }
            
            snipped.topAnchor.constraint(equalTo: $0.topAnchor, constant: 70).isActive = true
            snipped.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            snipped.widthAnchor.constraint(equalToConstant: 80).isActive = true
            snipped.heightAnchor.constraint(equalTo: snipped.widthAnchor).isActive = true
            
            name.topAnchor.constraint(equalTo: snipped.bottomAnchor, constant: 10).isActive = true
            name.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            name.leftAnchor.constraint(greaterThanOrEqualTo: $0.leftAnchor, constant: 30).isActive = true
            name.rightAnchor.constraint(lessThanOrEqualTo: $0.rightAnchor, constant: -30).isActive = true
            
            _duplicate.rightAnchor.constraint(equalTo: duplicate.leftAnchor, constant: -10).isActive = true
            _duplicate.centerYAnchor.constraint(equalTo: duplicate.centerYAnchor).isActive = true
            
            duplicate.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30).isActive = true
            duplicate.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 80).isActive = true
            
            next.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -80).isActive = true
            next.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
        }
        
        pages.page {
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
            
            let next = Button(icon: "arrow.right.circle.fill", color: .systemBlue)
            next.target = pages
            next.action = #selector(pages.next)
            $0.addSubview(next)
            
            let previous = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
            previous.target = pages
            previous.action = #selector(pages.previous)
            $0.addSubview(previous)
            
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
            
            next.leftAnchor.constraint(equalTo: $0.centerXAnchor, constant: 20).isActive = true
            next.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -80).isActive = true
            
            previous.rightAnchor.constraint(equalTo: $0.centerXAnchor, constant: -20).isActive = true
            previous.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -80).isActive = true
            
            let bytes = ByteCountFormatter()
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            segmented.selected.sink { [weak self] in
                guard let self = self else { return }
                original.isHidden = self.duplicate.state != .off || (self.duplicate.state == .off && $0 == 2)
                let image = self.images[$0]
                let data = NSBitmapImageRep(data: image.tiffRepresentation!)!.representation(using: .png, properties: [:])!
                scale.stringValue = formatter.string(from: .init(value: Int(image.size.width)))! + "×" + formatter.string(from: .init(value: Int(image.size.height)))! + "\n" + bytes.string(fromByteCount: .init(data.count))
            }.store(in: &self.subs)
        }
        
        pages.page {
            let title = Label(.key("Image.alt"), .medium(2))
            title.textColor = .secondaryLabelColor
            $0.addSubview(title)
            
            let field = Field()
            $0.addSubview(field)
            self.field = field
            
            let previous = Button(icon: "arrow.left.circle.fill", color: .systemBlue)
            previous.target = pages
            previous.action = #selector(pages.previous)
            $0.addSubview(previous)
            
            let add = Button(text: .key("Add"), background: .systemBlue, foreground: .controlTextColor)
            add.target = self
            add.action = #selector(submit)
            $0.addSubview(add)
            
            title.topAnchor.constraint(equalTo: $0.topAnchor, constant: 80).isActive = true
            title.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            field.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
            field.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            field.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            add.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            add.centerYAnchor.constraint(equalTo: previous.centerYAnchor).isActive = true
            
            previous.rightAnchor.constraint(equalTo: add.leftAnchor, constant: -40).isActive = true
            previous.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -80).isActive = true
        }
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        
        pages.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor).isActive = true
        pages.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor).isActive = true
        pages.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor).isActive = true
        pages.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor).isActive = true
    }
    
    @objc
    private func submit() {
        
    }
}

private extension NSImage {
    func scales(_ scales: [CGFloat]) -> [NSImage] {
        let original = NSBitmapImageRep(data: tiffRepresentation!)!
        let width = CGFloat(size.width)
        let height = CGFloat(size.height)
        return scales.map {
            let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: .init(width * $0), pixelsHigh: .init(height * $0),
                bitsPerSample: original.bitsPerSample,
                samplesPerPixel: original.samplesPerPixel,
                hasAlpha: original.hasAlpha,
                isPlanar: original.isPlanar,
                colorSpaceName: original.colorSpaceName,
                bytesPerRow: original.bytesPerRow,
                bitsPerPixel: original.bitsPerPixel)!
            
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)!
            draw(in: .init(origin: .zero, size: bitmap.size))
            NSGraphicsContext.restoreGraphicsState()

            let resizedImage = NSImage(size: bitmap.size)
            resizedImage.addRepresentation(bitmap)
            return resizedImage
        } + [self]
    }
}
