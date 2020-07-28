import AppKit
import Core

final class Name: Pop {
    private weak var field: Field!
    private weak var website: Website!
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, website: Website) {
        super.init(size: .init(width: 260, height: 200))
        self.website = website
        
        let header = Label(.key("New.entry"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let field = Field()
        field.stringValue = "text"
        contentViewController!.view.addSubview(field)
        self.field = field
        
        let add = Button(text: .key("Add"), background: .systemPink, foreground: .controlTextColor)
        add.target = self
        add.action = #selector(submit)
        contentViewController!.view.addSubview(add)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        contentViewController!.view.addSubview(cancel)
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        field.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        field.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        add.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 50).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: add.bottomAnchor, constant: 15).isActive = true
        
        show(relative: relative)
    }
    
    @objc private func submit() {
//        send("[\(titleField.stringValue)](\(urlField.stringValue))")
    }
}
