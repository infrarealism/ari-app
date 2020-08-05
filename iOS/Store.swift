import SwiftUI

struct Store: View {
    @Binding var display: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Purchases.are")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding()
                Button("Restore.purchases") {
                    
                }.frame(width: 200, height: 40)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .foregroundColor(.primary)
                    .padding()
                Circle()
            }.navigationBarTitle("Store", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.display = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }).foregroundColor(.secondary)
        }
    }
}
