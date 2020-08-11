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
                            .resizable()
                            .frame(width: 18, height: 24)
                            .foregroundColor(.pink)
                            .padding()
                        Spacer()
                }) {
                    Button(action: {
                        
                    }) {
                        Text("Share project")
                    }
                    Button(action: {
                        
                    }) {
                        Text("Share folder")
                    }
                }
            }.listStyle(GroupedListStyle())
                .navigationBarTitle(Text(verbatim: website.model.name), displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.website.close()
                    self.window.launch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
