import Foundation
import Core

struct Bookmark: Codable, Identifiable {
    var edited: Date
    let name: String
    let id: URL
    private let data: Data
    
    var access: URL? { data.access }
    var location: String { id.directory ?? id.absoluteString }
    
    static func open(_ url: URL) -> Self? {
        Website.load(url).map {
            .init($0.model.name, url: url)
        }
    }
    
    init(_ name: String, url: URL) {
        self.name = name
        id = url
        edited = .init()
        data = url.bookmark
    }
}
