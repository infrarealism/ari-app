import SwiftUI
import Combine
import Core

struct Launch: View {
    weak var window: UIWindow!
    @State private var sub: AnyCancellable?
    @State private var bookmarks = [Bookmark]()
    @State private var create = false
    @State private var store = false
    @State private var open = false
    @State private var how = false
    
    var body: some View {
        ScrollView {
            HStack {
                Button(action: {
                    self.how = true
                }) {
                    VStack {
                        Image(systemName: "info.circle.fill")
                            .font(.headline)
                        Text("How.to")
                            .font(.footnote)
                    }.padding()
                }.foregroundColor(.pink)
                    .padding()
                    .sheet(isPresented: $how) {
                        How(display: self.$how)
                    }
                Spacer()
                Button(action: {
                    self.store = true
                }) {
                    VStack {
                        Image(systemName: "cart.fill")
                            .font(.headline)
                        Text("Store")
                            .font(.footnote)
                    }.padding()
                }.foregroundColor(.pink)
                    .padding()
                    .sheet(isPresented: $store) {
                        Store(display: self.$store)
                    }
                Spacer()
                Button(action: {
                    self.open = true
                }) {
                    VStack {
                        Image(systemName: "archivebox.fill")
                            .font(.headline)
                        Text("Open")
                            .font(.footnote)
                    }.padding()
                }.foregroundColor(.pink)
                    .padding()
                    .sheet(isPresented: $open) {
                        Browse(type: "ari.website") {
                            self.window.receive($0)
                        }
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
                    self.open(item)
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
    
    private func open(_ bookmark: Bookmark) {
        session.update(bookmark)
        window.open(bookmark)
    }
}
