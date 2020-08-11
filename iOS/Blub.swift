import SwiftUI

struct Blub: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 40, height: 40)
                    .shadow(color: .init(.quaternaryLabel), radius: 3, x: -2, y: -2)
                    .shadow(color: .init(.quaternaryLabel), radius: 6, x: 4, y: 4)
                    .foregroundColor(.init(.systemBackground))
                Image(systemName: image)
                    .foregroundColor(.pink)
            }.padding()
        }
    }
}
