import Foundation
import Balam
import Core
import Combine

final class Session {
    private var subs = Set<AnyCancellable>()
    private let _bookmarks = Balam("bookmarks")
    private let _websites = Balam("websites")
    
    var bookmarks: Future <[Bookmark], Never> {
        .init { promise in
            self._bookmarks.remove(Bookmark.self) { !FileManager.default.fileExists(atPath: $0.url.path) }
            self._bookmarks.nodes(Bookmark.self).sink {
                promise(.success($0.sorted { $0.edited > $1.edited }))
            }.store(in: &self.subs)
        }
    }
    
    func create(_ category: Core.Category, bookmark: Bookmark) -> Website {
        var website = Website(bookmark.id, category: category)
        website.name = bookmark.name
        _websites.add(website)
        _bookmarks.add(bookmark)
        return website
    }
    
    func website(_ bookmark: Bookmark) -> Future <Website, Never> {
        .init { promise in
            var bookmark = bookmark
            bookmark.edited = .init()
            self._bookmarks.update(bookmark)
            self._websites.nodes(Website.self).sink {
                promise(.success($0.first { $0.id == bookmark.id }!))
            }.store(in: &self.subs)
        }
    }
}
