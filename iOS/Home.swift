import SwiftUI
import Core

struct Home: View {
    weak var window: UIWindow!
    let website: Website
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .resizable()
                        .frame(width: 25, height: 32)
                        .foregroundColor(.pink)
                        .padding()
                }.accentColor(.clear)
                Spacer()
            }.navigationBarTitle(Text(verbatim: website.model.name), displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.window.launch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
