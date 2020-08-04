import SwiftUI

struct Launch: View {
    weak var window: UIWindow!
    @State private var create = false
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack {
                    Image("logo")
                        .padding(.top, 50)
                    Button(action: {
                        self.create = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.foregroundColor(.pink)
                        .padding(.top, 20)
                    Text("New")
                        .font(.title)
                        .bold()
                    Text("Create")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }.sheet(isPresented: $create) {
            Create(window: self.window)
        }
    }
}
