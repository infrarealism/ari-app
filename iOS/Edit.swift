import SwiftUI
import Core
import Combine

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var id = Page.index.id
    
    var body: some View {
        ZStack {
            TextView(website: website, id: $id)
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    Blub(image: "text.badge.star") {
                        
                    }
                    Blub(image: "link") {
                        
                    }
                    Blub(image: "photo") {
                        
                    }
                }
                Spacer()
            }
        }
    }
}
