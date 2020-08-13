import SwiftUI
import Core

struct Photo: View {
    weak var website: Website!
    @Binding var image: UIImage?
    @Binding var name: String
    let action: (String) -> Void
    @State private var alternate = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Image.name", text: $name)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Image.alt", text: $alternate)
                        .textContentType(.none)
                        .keyboardType(.alphabet)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                }
            }.navigationBarTitle("Add.image", displayMode: .large)
                .navigationBarItems(leading:
                    Button(action: {
                        self.image = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }.accentColor(.clear), trailing:
                    Cta(title: "Add", background: .pink, width: 80) {
                        try! self.image!.jpegData(compressionQuality: 1)!.write(to: self.website.url!.appendingPathComponent(self.name), options: .atomic)
                        self.action("![\(self.alternate)](\(self.name))")
                        self.name = ""
                        self.image = nil
                    })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
