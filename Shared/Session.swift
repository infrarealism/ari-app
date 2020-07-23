import Foundation
import Balam
import Core
import Combine

final class Session {
    var user = CurrentValueSubject<User, Never>(.init())
    private var sub: AnyCancellable?
    let store = Balam("Ari")
    
    var bookmarks: Future <[Bookmark], Never> {
        .init { promise in
            var sub: AnyCancellable?
            self.store.remove(Bookmark.self) { !FileManager.default.fileExists(atPath: $0.id.path) }
            sub = self.store.nodes(Bookmark.self).sink {
                promise(.success($0.sorted { $0.edited > $1.edited }))
                sub?.cancel()
            }
        }
    }
    
    func load() {
        var sub: AnyCancellable?
        sub = store.nodes(User.self).sink {
            if let user = $0.first {
                self.user.value = user
            } else {
                self.store.add(self.user.value)
            }
            sub?.cancel()
            self.sub = self.user.dropFirst().sink {
                self.store.update($0)
            }
        }
    }
    
    func add(_ bookmark: Bookmark) {
        store.add(bookmark)
    }
}
