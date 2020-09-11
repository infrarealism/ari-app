import SwiftUI

struct How: View {
    @Binding var display: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack {
                        Image(systemName: "dot.square")
                        Text("Single")
                        Spacer()
                }) {
                    Text("How.single")
                        .padding(.vertical)
                }
                Section(header:
                    HStack {
                        Image(systemName: "square.stack.3d.up")
                        Text("Blog")
                        Spacer()
                }) {
                    Text("How.blog")
                        .padding(.vertical)
                }
            }.listStyle(GroupedListStyle())
                .navigationBarTitle("How.it.works", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.display = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.pink)
                }.accentColor(.clear))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
