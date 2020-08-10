import SwiftUI
import Core
import Combine

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var id = Page.index.id
    
    var body: some View {
        TextView(website: website, id: $id)
    }
}
