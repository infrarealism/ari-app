import UIKit

final class Blob: Control {
    override var enabled: Bool {
        didSet {
            update()
        }
    }
    
    private weak var circle: UIView!
    private weak var icon: UIImageView!
    
    required init?(coder: NSCoder) { nil }
    init(icon: String) {
        super.init()
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.isUserInteractionEnabled = false
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 24
        addSubview(circle)
        self.circle = circle
        
        let icon = UIImageView(image: UIImage(systemName: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .center
        icon.clipsToBounds = true
        addSubview(icon)
        self.icon = icon
        
        widthAnchor.constraint(equalToConstant: 60).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        circle.widthAnchor.constraint(equalToConstant: 48).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        update()
    }
    
    func update() {
        circle.backgroundColor = enabled ? .secondarySystemBackground : .tertiarySystemBackground
        icon.tintColor = enabled ? .label : .tertiaryLabel
    }
    
    override func hoverOn() {
        alpha = 0.3
    }
    
    override func hoverOff() {
        alpha = 1
    }
}
