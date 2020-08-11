import SwiftUI
import Core

struct Design: View {
    weak var website: Website!
    @State private var primary: Core.Color!
    @State private var secondary: Core.Color!
    
    var body: some View {
        NavigationView {
            List {
                if primary != nil {
                    Section(footer: Picker(selected: $primary)) {
                        VStack {
                                HStack {
                                    Text("Primary.title")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                HStack {
                                    Text("Primary.description")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                        }
                    }
                }
                if secondary != nil {
                    Section(footer: Picker(selected: $secondary)) {
                        VStack {
                                HStack {
                                    Text("Secondary.title")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                HStack {
                                    Text("Secondary.description")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
                .navigationBarTitle("Colours", displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.primary = self.website.model.style.primary
                self.secondary = self.website.model.style.secondary
        }.onReceive([primary].publisher) {
            guard let color = $0, self.website.model.style.primary != color else { return }
            self.website.model.style.primary = color
            
        }.onReceive([secondary].publisher) {
            guard let color = $0, self.website.model.style.secondary != color else { return }
            self.website.model.style.secondary = color
        }
    }
}

private struct Picker: View {
    @Binding var selected: Core.Color!
    
    var body: some View {
        HStack {
            Spacer()
            Item(color: .blue, selected: $selected)
            Item(color: .indigo, selected: $selected)
            Item(color: .purple, selected: $selected)
            Item(color: .pink, selected: $selected)
            Item(color: .orange, selected: $selected)
            Spacer()
        }.padding()
    }
}

private struct Item: View {
    let color: Core.Color
    @Binding var selected: Core.Color!
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.selected = self.color
            }
        }) {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.init(color.color))
                .frame(width: selected == color ? 46 : 28, height: selected == color ? 46 : 28)
                .opacity(selected == color ? 1 : 0.4)
                .padding(.all, 3)
        }.accentColor(.clear)
    }
}

private extension Core.Color {
    var color: UIColor {
        .init(red: .init(red), green: .init(green), blue: .init(blue), alpha: 1)
    }
}
