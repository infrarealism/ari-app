import SwiftUI
import Core

struct Home: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var project = false
    @State private var folder = false
    
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
                        self.project = true
                    }) {
                        Text("Share.project")
                    }.actionSheet(isPresented: $project) {
                        ActionSheet(title: <#T##Text#>, message: <#T##Text?#>, buttons: <#T##[ActionSheet.Button]#>)
                    }
                    Button(action: {
                        self.folder = true
                    }) {
                        Text("Share.folder")
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
