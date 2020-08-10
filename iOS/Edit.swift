import SwiftUI
import Core
import Combine

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var id = Page.index.id
    @State private var text = ""
    
    var body: some View {
        TextView(text: $text)
    }
}
