import SwiftUI
import StoreKit

struct Store: View {
    @Binding var display: Bool
    @State private var products = [SKProduct]()
    @State private var formatter = NumberFormatter()
    private let purchases = Purchases()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Purchases.are")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding()
                Button("Restore.purchases") {
                    withAnimation {
                        self.products = []
                    }
                    self.purchases.restore()
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
                ForEach(products, id: \.self) { product in
                    Item(purchase: Purchase(rawValue: product.productIdentifier)!, price: self.price(product)) {
                        withAnimation {
                            self.products = []
                        }
                        self.purchases.purchase(product)
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
        }.onReceive(purchases.products.dropFirst().receive(on: DispatchQueue.main)) { products in
            withAnimation {
                self.products = products
            }
        }.onAppear {
            self.formatter.numberStyle = .currencyISOCode
            self.purchases.load()
        }
    }
    
    private func price(_ product: SKProduct) -> String {
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)!
    }
}

private struct Item: View {
    let purchase: Purchase
    let price: String
    let action: () -> Void
    
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
            Text(verbatim: price)
                .font(.subheadline)
                .foregroundColor(.primary)
            if session.user.value.purchases.contains(purchase) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.init(.systemIndigo))
                    .padding()
            } else {
                Button("Purchase", action: action)
                    .frame(width: 120, height: 36)
                    .background(Color.pink)
                    .cornerRadius(18)
                    .foregroundColor(.primary)
                    .padding()
            }
        }
    }
}
