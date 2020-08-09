import SwiftUI
import Core

struct Main: View {
    weak var window: UIWindow!
    let website: Website
    
    var body: some View {
        TabView {
            Home(window: window)
                .tabItem {
                    Image(systemName: website.icon)
                    Text("Home")
                }
            Circle()
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
            Circle()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }.accentColor(.pink)
    }
}
