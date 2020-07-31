import AppKit

final class Link: Pop<String> {
    private weak var titleField: Field!
    private weak var urlField: Field!
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, text: String) {
        super.init(size: .init(width: 260, height: 340))
        
        let header = Label(.key("Link.header"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let title = Label(.key("Link.title"), .medium(2))
        title.textColor = .secondaryLabelColor
        contentViewController!.view.addSubview(title)
        
        let titleField = Field()
        titleField.stringValue = text
        contentViewController!.view.addSubview(titleField)
        self.titleField = titleField
        
        let url = Label(.key("Link.url"), .medium(2))
        url.textColor = .secondaryLabelColor
        contentViewController!.view.addSubview(url)
        
        let urlField = Field()
        urlField.placeholderString = .key("Link.placeholder")
        contentViewController!.view.addSubview(urlField)
        self.urlField = urlField
        
        let add = Button(text: .key("Add"), background: .systemPink, foreground: .controlTextColor)
        add.target = self
        add.action = #selector(submit)
        contentViewController!.view.addSubview(add)
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        title.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        
        titleField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        titleField.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        titleField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        url.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20).isActive = true
        url.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        
        urlField.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 10).isActive = true
        urlField.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        urlField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        add.bottomAnchor.constraint(equalTo: _cancel.topAnchor, constant: -15).isActive = true
        
        show(relative: relative)
    }
    
    @objc private func submit() {
        send("[\(titleField.stringValue)](\(urlField.stringValue))")
    }
}
