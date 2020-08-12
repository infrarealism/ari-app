import SwiftUI
import Combine

struct Launch: View {
    weak var window: UIWindow!
    @State private var sub: AnyCancellable?
    @State private var bookmarks = [Bookmark]()
    @State private var create = false
    @State private var store = false
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Button(action: {
                    self.store = true
                }) {
                    Image(systemName: "cart.fill")
                        .padding()
                }.foregroundColor(.pink)
                    .padding()
                    .sheet(isPresented: $store) {
                        Store(display: self.$store)
                    }
            }
            HStack {
                Spacer()
                VStack {
                    Image("logo")
                    Button(action: {
                        self.create = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }.foregroundColor(.pink)
                        .padding(.top, 20)
                        .sheet(isPresented: $create) {
                            Create(window: self.window, display: self.$create)
                        }
                    Text("New")
                        .font(.title)
                        .bold()
                    Text("Create")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Spacer()
                .frame(height: 40)
            ForEach(bookmarks) { item in
                Spacer()
                    .frame(height: 2)
                Button(action: {
                    var item = item
                    item.edited = .init()
                    session.update(item)
                    self.window.open(item)
                }) {
                    VStack {
                        HStack {
                            Text(verbatim: item.name)
                                .font(Font.title.bold())
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        HStack {
                            Text(verbatim: item.location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }.padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
                }.accentColor(.clear)
                    .background(Color(.secondarySystemBackground))
            }
        }.onAppear {
            self.sub = session.bookmarks.sink {
                self.bookmarks = $0
            }
        }
    }
}
