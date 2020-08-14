import SwiftUI
import Core

extension Edit {
    struct Pages: View {
        weak var website: Website!
        @Binding var id: String
        @Binding var display: Bool
        @State private var create = false
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(website.model.pages.sorted { $0.created < $1.created }) { item in
                        Button(action: {
                            self.id = item.id
                            self.display = false
                        }) {
                            HStack {
                                Text(verbatim: item.id)
                                    .font(.headline)
                                    .foregroundColor(self.id == item.id ? .primary : .secondary)
                                Spacer()
                                if self.id == item.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.pink)
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
                    .navigationBarTitle("Pages", displayMode: .large)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.display = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }.accentColor(.clear), trailing:
                        Button(action: {
                            self.create = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.pink)
                    }.accentColor(.clear))
                    .sheet(isPresented: $create) {
                        Name(website: self.website, display: self.$create) {
                            (self.website as! Website.Blog).add(id: $0)
                            self.id = self.website.model.pages.sorted { $0.created > $1.created }.first!.id
                            self.display = false
                        }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
