import SwiftUI
import Core

struct Info: View {
    weak var website: Website!
    let id: String
    @Binding var display: Bool
    @State private var title = ""
    @State private var description = ""
    @State private var keywords = ""
    @State private var author = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Keywords", text: $keywords)
                    TextField("Author", text: $author)
                }
            }.navigationBarTitle("Page.details", displayMode: .large)
            .navigationBarItems(leading:
                Button(action: {
                    self.display = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                        .padding()
                }.accentColor(.clear), trailing:
                Cta(title: "Save", background: .pink, width: 80) {
                    var page = self.website.model.pages.first { $0.id == self.id }!
                    page.title = self.title
                    page.description = self.description
                    page.keywords = self.keywords
                    page.author = self.author
                    self.website.update(page)
                    self.display = false
                })
        }.navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                let page = self.website.model.pages.first { $0.id == self.id }!
                self.title = page.title
                self.description = page.description
                self.keywords = page.keywords
                self.author = page.author
        }
    }
}
