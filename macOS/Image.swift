import AppKit

final class Image: Pop {
    
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        contentSize = .init(width: 320, height: 260)
        
        let header = Label(.key("Image.header"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        let pages = Pages()
        contentViewController!.view.addSubview(pages)
        
        pages.page {
            let title = Label("", .medium(2))
            title.textColor = .secondaryLabelColor
            $0.addSubview(title)
            
            let button = Button(text: .key("Select.image"), background: .systemPink, foreground: .controlTextColor)
            button.target = self
            button.action = #selector(file)
            $0.addSubview(button)
            
            title.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            title.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
            button.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
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
    private func file() {
        let browse = NSOpenPanel()
        browse.allowedFileTypes = NSImage.imageTypes
        browse.begin { [weak self] in
            guard $0 == .OK, let url = browse.url else { return }
            Swift.print(url)
        }
    }
    
    @objc
    private func submit() {
        
    }
}
