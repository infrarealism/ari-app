import SwiftUI
import Core

struct Main: View {
    weak var window: UIWindow!
    let website: Website
    
    var body: some View {
        TabView {
            Home(window: window, website: website)
                .tabItem {
                    Image(systemName: website.icon)
                    Text("Home")
                }
            Edit(window: window, website: website)
                .tabItem {
                    Image(systemName: "hammer")
                    Text("Edit")
                }
            Circle()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("Style")
                }
            Circle()
                .tabItem {
                    Image(systemName: "paperplane")
                    Text("Preview")
                }
        }.accentColor(.pink)
    }
}
