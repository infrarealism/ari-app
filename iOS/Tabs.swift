import SwiftUI

struct Tabs: View {
    var body: some View {
        TabView {
            Circle()
                .tabItem {
                    Image(systemName: "app.fill")
                    Text("Home")
                }
            Circle()
                .tabItem {
                    Image(systemName: "textformat.size")
                    Text("Type")
                }
            Circle()
                .tabItem {
                    Image(systemName: "circle.lefthalf.fill")
                    Text("Colors")
                }
            Circle()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Features")
                }
            Circle()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }.accentColor(.pink)
    }
}
