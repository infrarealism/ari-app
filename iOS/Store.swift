import SwiftUI
import StoreKit

struct Store: View {
    @Binding var display: Bool
    @State private var products = [SKProduct]()
    private let purchases = Purchases()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Purchases.are")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding()
                Button("Restore.purchases") {
                    
                }.frame(width: 200, height: 40)
                    .background(Color(.systemIndigo))
                    .cornerRadius(20)
                    .foregroundColor(.primary)
                    .padding()
                if products.isEmpty {
                    Text("Loading")
                        .font(Font.caption.bold())
                        .foregroundColor(.secondary)
                        .padding()
                }
                ForEach(products, id: \.self) { _ in
                    Circle()
                }
            }.navigationBarTitle("Store", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    self.display = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }).foregroundColor(.secondary)
        }.onReceive(purchases.products.dropFirst().receive(on: DispatchQueue.main)) {
            self.products = $0
        }.onAppear {
            self.purchases.load()
        }
    }
}
