import AppKit

final class Image: Pop {
    private weak var name: Label!
    private let url: URL
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, url: URL) {
        self.url = url
        super.init(relative: relative, size: .init(width: 320, height: 260))
        
        let header = Label(.key("Add.image"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        let pages = Pages()
        contentViewController!.view.addSubview(pages)
        
        pages.page {
            let name = Label("", .medium(2))
            name.textColor = .secondaryLabelColor
            $0.addSubview(name)
            self.name = name
            
            let button = Button(text: .key("Select.image"), background: .systemPink, foreground: .controlTextColor)
            $0.addSubview(button)
            
            name.topAnchor.constraint(equalTo: $0.topAnchor, constant: 100).isActive = true
            name.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
            
            button.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20).isActive = true
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
    private func submit() {
        
    }
}
