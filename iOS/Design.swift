import SwiftUI
import Core

struct Design: View {
    weak var website: Website!
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Picker(selected: website.model.style.primary) {
                    self.website.model.style.primary = $0
                }) {
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
                Section(footer: Picker(selected: website.model.style.secondary){
                    self.website.model.style.secondary = $0
                }) {
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
            }.listStyle(GroupedListStyle())
                .navigationBarTitle("Colours", displayMode: .large)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct Picker: View {
    @State var selected: Core.Color
    let action: (Core.Color) -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Item(color: .blue, selected: $selected, action: action)
            Item(color: .indigo, selected: $selected, action: action)
            Item(color: .purple, selected: $selected, action: action)
            Item(color: .pink, selected: $selected, action: action)
            Item(color: .orange, selected: $selected, action: action)
            Spacer()
        }.padding()
    }
}

private struct Item: View {
    let color: Core.Color
    @Binding var selected: Core.Color
    let action: (Core.Color) -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.selected = self.color
            }
            self.action(self.color)
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
