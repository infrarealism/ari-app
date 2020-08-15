import SwiftUI
import Core

struct Home: View {
    weak var window: UIWindow!
    weak var website: Website!
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack {
                        Spacer()
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title)
                            .foregroundColor(.pink)
                            .padding()
                        Spacer()
                }) {
                    Button(action: {
                        self.window.share([self.website.file])
                    }) {
                        Text("Share.project")
                    }
                }
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
