import SwiftUI
import Core
import Combine

struct Edit: View {
    weak var window: UIWindow!
    weak var website: Website!
    @State private var id = Page.index.id
    @State private var edit = false
    @State private var link = false
    @State private var photo = false
    @State private var image: UIImage?
    @State private var imageName = ""
    private let insert = PassthroughSubject<String, Never>()
    private let selected = CurrentValueSubject<String, Never>(.init())
    
    var body: some View {
        ZStack {
            TextView(website: website, insert: insert, selected: selected, id: $id)
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    .sheet(isPresented: .init(get: {
                        self.image != nil
                    }, set: { _ in
                        self.image = nil
                    })) {
                        Photo(website: self.website, image: self.$image, name: self.$imageName) {
                            self.insert.send($0)
                        }
                    }
                    Blub(image: "link") {
                        self.link = true
                    }.sheet(isPresented: $link) {
                        Link(title: self.selected.value, display: self.$link) {
                            self.insert.send($0)
                        }
                    }
                    Blub(image: "photo") {
                        self.photo = true
                    }.sheet(isPresented: $photo) {
                        Photo.Picker(image: self.$image, name: self.$imageName, display: self.$photo)
                    }
                }.padding(.trailing, 10)
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Blub(image: "text.badge.star") {
                        self.edit = true
                    }.sheet(isPresented: $edit) {
                        Info(website: self.website, id: self.id, display: self.$edit)
                    }
                }.padding(.all, 10)
            }
        }
    }
}
