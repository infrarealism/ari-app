import Foundation

struct Bookmark: Codable, Identifiable {
    var name = ""
    var edited: Date
    let id: URL
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
            NSString(string: id.path.replacingOccurrences(of: $0, with: "~")).abbreviatingWithTildeInPath
        } ?? id.absoluteString
    }
    
    init(_ url: URL) {
        id = url
        edited = .init()
        data = try! url.bookmarkData(options: .withSecurityScope)
    }
}
