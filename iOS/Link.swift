import SwiftUI

struct Link: View {
    @State var title: String
    @Binding var display: Bool
    let action: (String) -> Void
    @State private var url = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Link.title", text: $title)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                    TextField("Link.url", text: $url)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }.navigationBarTitle("Link.header", displayMode: .large)
                .navigationBarItems(leading:
                    Button(action: {
                        self.display = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }.accentColor(.clear), trailing:
                    Cta(title: "Add", background: .pink, width: 80) {
                        self.action("[\(self.title)](\(self.url))")
                        self.display = false
                    })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
