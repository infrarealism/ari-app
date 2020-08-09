import SwiftUI

struct Home: View {
    weak var window: UIWindow!
    
    var body: some View {
        NavigationView {
            Circle()
                .navigationBarTitle("Home", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.window.launch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
