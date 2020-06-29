import Foundation

struct Bookmark: Codable, Identifiable {
    var edited: Date
    let id: URL
    private let access: Data
    
    var acccess: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: access, options: .withSecurityScope, bookmarkDataIsStale: &stale)).flatMap {
            $0.startAccessingSecurityScopedResource() ? $0 : nil
        }
    }
    
    init(_ url: URL) {
        id = url
        edited = .init()
        access = try! url.bookmarkData(options: .withSecurityScope)
    }
}
