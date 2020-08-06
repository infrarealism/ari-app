import SwiftUI

struct Launch: View {
    weak var window: UIWindow!
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
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding()
                }.foregroundColor(.init(.systemIndigo))
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
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.foregroundColor(.pink)
                        .padding(.top, 20)
                        .sheet(isPresented: $create) {
                            Create(window: self.window)
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
        }
    }
}
