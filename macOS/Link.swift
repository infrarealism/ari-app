import AppKit
import Combine

final class Link: NSPopover, Publisher, Subscription {
    typealias Output = String
    typealias Failure = Never
    var subscription: AnyCancellable?
    private weak var titleField: Field!
    private weak var urlField: Field!
    private var subscriber: AnySubscriber<Output, Failure>?
    
    deinit {
        print("pop gone")
    }
    
    required init?(coder: NSCoder) { nil }
    override init() {
        
        super.init()
        contentSize = .init(width: 260, height: 340)
        behavior = .transient
        let view = NSView()
        
        let header = Label(.key("Link.header"), .bold(4))
        view.addSubview(header)
        
        let title = Label(.key("Link.title"), .medium(2))
        title.textColor = .secondaryLabelColor
        view.addSubview(title)
        
        let titleField = Field()
        view.addSubview(titleField)
        self.titleField = titleField
        
        let url = Label(.key("Link.url"), .medium(2))
        url.textColor = .secondaryLabelColor
        view.addSubview(url)
        
        let urlField = Field()
        urlField.placeholderString = .key("Link.placeholder")
        view.addSubview(urlField)
        self.urlField = urlField
        
        let add = Button(text: .key("Add"), background: .systemBlue, foreground: .controlTextColor)
        add.target = self
        add.action = #selector(self.add)
        view.addSubview(add)
        
        let cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        cancel.target = self
        cancel.action = #selector(close)
        view.addSubview(cancel)
        
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
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
        
        add.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        add.topAnchor.constraint(equalTo: urlField.bottomAnchor, constant: 50).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo: add.bottomAnchor, constant: 15).isActive = true
        
        contentViewController = .init()
        contentViewController!.view = view
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        self.subscriber = .init(subscriber)
        subscriber.receive(subscription: self)
    }
    
    func request(_: Subscribers.Demand) {
        
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc
    private func add() {
        _ = subscriber?.receive("hello world")
        close()
    }
    
    override func close() {
        contentViewController = nil
        super.close()
    }
}


/*
 Images

 ![GitHub Logo](/images/logo.png)
 Format: ![Alt Text](url)
 Links

 http://github.com - automatic!
 [GitHub](http://github.com)

 */
