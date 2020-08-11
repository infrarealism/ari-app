import SwiftUI

struct Blub: View {
    let title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .frame(width: 120, height: 44)
                    .shadow(color: .secondary, radius: 2, x: -2, y: -2)
                    .shadow(color: .init(.systemBackground), radius: 2, x: 2, y: 2)
                    .foregroundColor(.init(.systemBackground))
                Text(title)
                    .foregroundColor(.primary)
                    .font(.footnote)
                    .bold()
            }.padding()
        }
    }
}
