import Foundation
import Core

struct Bookmark: Codable, Identifiable {
    var edited: Date
    let name: String
    let id: URL
    private let data: Data
    
    var access: URL? { data.access }
    var location: String { id.directory ?? id.absoluteString }
    
    init(_ name: String, url: URL) {
        self.name = name
        id = url
        edited = .init()
        data = try! url.bookmarkData(options: .withSecurityScope)
    }
}
