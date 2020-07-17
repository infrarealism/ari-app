import AppKit
import Combine

class Pop: NSPopover, Publisher, Subscription, NSPopoverDelegate {
    typealias Output = String
    typealias Failure = Never
    var subscription: AnyCancellable?
    private var subscriber: AnySubscriber<Output, Failure>?
    
    required init?(coder: NSCoder) { nil }
    init(size: CGSize) {
        super.init()
        behavior = .transient
        contentSize = size
        contentViewController = .init()
        contentViewController!.view = .init()
    }
    
    func show(relative: NSView) {
        show(relativeTo: relative.bounds, of: relative, preferredEdge: .minY)
//        contentViewController!.view.window!.makeKey()
    }
    
    func send(_ message: Output) {
        _ = subscriber?.receive(message)
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
