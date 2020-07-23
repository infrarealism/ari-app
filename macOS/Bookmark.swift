import Foundation
import Core

struct Bookmark: Codable, Identifiable {
    var name = ""
    var edited: Date
    let id: URL
    private let data: Data
    
    var access: URL? { data.access }
    var location: String { id.directory ?? id.absoluteString }
    
    init(_ url: URL) {
        id = url
        edited = .init()
        data = try! url.bookmarkData(options: .withSecurityScope)
    }
}
