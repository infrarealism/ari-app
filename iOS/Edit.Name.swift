import SwiftUI
import Core

extension Edit {
    struct Name: View {
        weak var website: Website!
        @Binding var display: Bool
        let action: (String) -> Void
        @State private var placeholder = ""
        @State private var name = ""
        
        var body: some View {
            NavigationView {
                Form {
                    Section {
                        TextField(placeholder, text: $name)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }.navigationBarTitle("New.entry", displayMode: .large)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.display = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }.accentColor(.clear), trailing:
                        Cta(title: "Add", background: .pink, width: 80) {
                            self.display = false
                            self.action(self.name.isEmpty ? self.placeholder : self.name)
                        })
            }.navigationViewStyle(StackNavigationViewStyle()).onAppear {
                let formater = DateFormatter()
                formater.dateFormat = "dd MM yyyy"
                self.placeholder = formater.string(from: .init())
            }
        }
    }
}
