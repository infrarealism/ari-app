import Foundation
import Balam
import Core
import Combine

final class Session {
    var user = CurrentValueSubject<User, Never>(.init())
    private let _bookmarks = Balam("Bookmarks")
    private let _websites = Balam("Websites")
    private let _user = Balam("User")
    
    var bookmarks: Future <[Bookmark], Never> {
        .init { promise in
            var sub: AnyCancellable?
            self._bookmarks.remove(Bookmark.self) { !FileManager.default.fileExists(atPath: $0.url.path) }
            sub = self._bookmarks.nodes(Bookmark.self).sink {
                promise(.success($0.sorted { $0.edited > $1.edited }))
                sub?.cancel()
            }
        }
    }
    
    func load() {
        var sub: AnyCancellable?
        sub = _user.nodes(User.self).sink {
            if let user = $0.first {
                self.user.value = user
            } else {
                self._user.add(self.user.value)
            }
            sub?.cancel()
        }
    }
    
    func create(_ category: Core.Category, bookmark: Bookmark) -> Website {
        var website = category.make(id: bookmark.id)
        website.name = bookmark.name
        _websites.add(website)
        _bookmarks.add(bookmark)
        return website
    }
    
    func website(_ bookmark: Bookmark) -> Future <Website, Never> {
        .init { promise in
            var sub: AnyCancellable?
            var bookmark = bookmark
            bookmark.edited = .init()
            self._bookmarks.update(bookmark)
            sub = self._websites.nodes(Website.self).sink {
                promise(.success($0.first { $0.id == bookmark.id }!))
                sub?.cancel()
            }
        }
    }
    
    func update(website: Website) {
        _websites.update(website)
    }
}
