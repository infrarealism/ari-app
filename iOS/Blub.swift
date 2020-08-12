import SwiftUI

struct Blub: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .frame(width: 44, height: 44)
                    .shadow(color: .init(.quaternaryLabel), radius: 2, x: -1, y: -1)
                    .shadow(color: .init(.quaternaryLabel), radius: 7, x: 5, y: 5)
                    .foregroundColor(.init(.systemBackground))
                Image(systemName: image)
                    .foregroundColor(.pink)
            }.frame(width: 70, height: 70)
        }
    }
}
