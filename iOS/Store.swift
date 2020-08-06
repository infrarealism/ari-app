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
                Spacer()
                    .frame(height: 40)
                if products.isEmpty {
                    Text("Loading")
                        .font(Font.caption.bold())
                        .foregroundColor(.secondary)
                        .padding()
                }
                ForEach(products, id: \.self) {
                    Item(product: $0, purchase: Purchase(rawValue: $0.productIdentifier)!) { _ in
                        
                    }
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

private struct Item: View {
    let product: SKProduct
    let purchase: Purchase
    let action: (SKProduct) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: purchase.image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.init(.systemIndigo))
                Spacer()
                    .frame(width: 10)
                Text(verbatim: purchase.title)
                    .font(Font.title.bold())
                    .foregroundColor(.init(.systemIndigo))
            }
            Text(verbatim: purchase.subtitle)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
