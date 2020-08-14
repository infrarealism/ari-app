import SwiftUI
import Core

struct Home: View {
    weak var window: UIWindow!
    weak var website: Website!
    
    var body: some View {
        NavigationView {
            List {
                EmptyView()
            }.listStyle(GroupedListStyle())
                .navigationBarTitle(Text(verbatim: website.model.name), displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.website.close()
                    self.window.launch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
