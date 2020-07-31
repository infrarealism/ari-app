import AppKit
import Combine

class Pop<Output>: NSPopover, Publisher, Subscription, NSPopoverDelegate {
    typealias Failure = Never
    var subscription: AnyCancellable?
    private(set) weak var _cancel: Button!
    private var subscriber: AnySubscriber<Output, Failure>?

    required init?(coder: NSCoder) { nil }
    init(size: CGSize) {
        super.init()
        behavior = .transient
        contentSize = size
        contentViewController = .init()
        contentViewController!.view = .init()
        
        let _cancel = Button(text: .key("Cancel"), background: .clear, foreground: .secondaryLabelColor)
        _cancel.target = self
        _cancel.action = #selector(close)
        contentViewController!.view.addSubview(_cancel)
        self._cancel = _cancel
        
        _cancel.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
        _cancel.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
    }
    
    func show(relative: NSView) {
        show(relativeTo: relative.bounds, of: relative, preferredEdge: .minY)
    }
    
    func send(_ output: Output) {
        _ = subscriber?.receive(output)
        close()
    }
    
    func popoverDidClose(_: Notification) {
        subscription?.cancel()
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
}
