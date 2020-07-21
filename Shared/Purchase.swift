import Foundation

enum Purchase: String, CaseIterable, Codable {
    case
    blog = "ari.app.blog"
    
    var image: String {
        switch self {
        case .blog: return "square.stack.3d.fill"
        }
    }
    
    var title: String {
        .key(rawValue + ".title")
    }
    
    var subtitle: String {
        .key(rawValue + ".subtitle")
    }
}
