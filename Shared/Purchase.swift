import Foundation

enum Purchase: String, CaseIterable, Codable {
    case
    blog = "ari.app.blog"
    
    var image: String {
        switch self {
        case .blog: return ""
        }
    }
    
    var title: String {
        switch self {
        case .blog: return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .blog: return ""
        }
    }
}
