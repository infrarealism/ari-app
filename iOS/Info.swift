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
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                    TextField("Description", text: $description)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                    TextField("Keywords", text: $keywords)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Author", text: $author)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }.navigationBarTitle("Page.details", displayMode: .large)
            .navigationBarItems(leading:
                Button(action: {
                    self.display = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
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
