import Foundation

struct Bookmark: Codable, Identifiable {
    var name = ""
    var edited: Date
    let id: UUID
    let url: URL
    private let data: Data
    
    var access: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: data, options: .withSecurityScope, bookmarkDataIsStale: &stale)).flatMap {
            $0.startAccessingSecurityScopedResource() ? $0 : nil
        }
    }
    
    var location: String {
        getpwuid(getuid()).pointee.pw_dir.map {
            FileManager.default.string(withFileSystemRepresentation: $0, length: .init(strlen($0)))
        }.map {
            NSString(string: url.path.replacingOccurrences(of: $0, with: "~")).abbreviatingWithTildeInPath
        } ?? url.absoluteString
    }
    
    init(_ url: URL) {
        self.url = url
        edited = .init()
        data = try! url.bookmarkData(options: .withSecurityScope)
        id = .init()
    }
}
