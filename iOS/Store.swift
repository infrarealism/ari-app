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
                Cta(title: "Restore.purchases", background: .pink, width: 200) {
                    withAnimation {
                        self.products = []
                    }
                    self.purchases.restore()
                }
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
                        .frame(width: 22, height: 22)
                        .foregroundColor(.pink)
                }.accentColor(.clear))
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
                Cta(title: "Purchase", background: .pink, width: 120, action: action)
            }
        }
    }
}
