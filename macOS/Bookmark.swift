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
    
    var name: String {
        getpwuid(getuid()).pointee.pw_dir.map {
            FileManager.default.string(withFileSystemRepresentation: $0, length: .init(strlen($0)))
        }.map {
            NSString(string: id.deletingLastPathComponent().path.replacingOccurrences(of: $0, with: "~")).abbreviatingWithTildeInPath
        } ?? id.absoluteString
    }
    
    init(_ url: URL) {
        id = url
        edited = .init()
        access = try! url.bookmarkData(options: .withSecurityScope)
    }
}
