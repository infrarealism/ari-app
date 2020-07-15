import AppKit

final class Image: Pop {
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        contentSize = .init(width: 260, height: 340)
        
        let header = Label(.key("Image.header"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let title = Label(.key("Link.title"), .medium(2))
        title.textColor = .secondaryLabelColor
        contentViewController!.view.addSubview(title)
        
        let add = Button(text: .key("Add"), background: .systemBlue, foreground: .controlTextColor)
        add.target = self
        add.action = #selector(submit)
        contentViewController!.view.addSubview(add)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        title.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        add.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -15).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
    }
    
    @objc
    private func submit() {
        
    }
}
