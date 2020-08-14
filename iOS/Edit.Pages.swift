import SwiftUI
import Core

extension Edit {
    struct Pages: View {
        weak var website: Website!
        @Binding var id: String
        @Binding var display: Bool
        
        var body: some View {
            NavigationView {
                List {
                    Circle()
                }.navigationBarTitle("Pages", displayMode: .large)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.display = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }.accentColor(.clear), trailing:
                        Button(action: {
                            self.display = false
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.pink)
                        }.accentColor(.clear))
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
