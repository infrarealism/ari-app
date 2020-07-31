import AppKit
import Core

final class Name: Pop<Void>, NSTextFieldDelegate {
    private weak var field: Field!
    private weak var website: Website.Blog!
    private weak var warning: Label!
    
    required init?(coder: NSCoder) { nil }
    init(relative: NSView, website: Website.Blog) {
        super.init(size: .init(width: 260, height: 250))
        self.website = website
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        
        let header = Label(.key("New.entry"), .bold(4))
        contentViewController!.view.addSubview(header)
        
        let field = Field()
        field.placeholderString = formater.string(from: .init())
        field.delegate = self
        contentViewController!.view.addSubview(field)
        self.field = field
        
        let warning = Label(.key("Name.exists"), .medium())
        warning.isHidden = true
        warning.textColor = .systemRed
        warning.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentViewController!.view.addSubview(warning)
        self.warning = warning
        
        let add = Button(text: .key("Add"), background: .systemPink, foreground: .controlTextColor)
        add.target = self
        add.action = #selector(save)
        contentViewController!.view.addSubview(add)
        
        header.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
        
        field.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        field.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        warning.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10).isActive = true
        warning.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        warning.rightAnchor.constraint(lessThanOrEqualTo: field.rightAnchor).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        add.bottomAnchor.constraint(equalTo: _cancel.topAnchor, constant: -15).isActive = true
        
        show(relative: relative)
        update()
    }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        if doCommandBy == #selector(insertNewline) {
            save()
            return true
        }
        return false
    }
    
    func controlTextDidChange(_: Notification) {
        update()
    }
    
    private func update() {
        let id = field.stringValue.isEmpty ? field.placeholderString! : field.stringValue
        warning.isHidden = !website.model.pages.contains { $0.id == id }
    }
    
    @objc private func save() {
        let id = field.stringValue.isEmpty ? field.placeholderString! : field.stringValue
        website.add(id: id)
        send(())
    }
}
