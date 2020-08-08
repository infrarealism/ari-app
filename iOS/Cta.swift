import SwiftUI

struct Cta: View {
    let title: LocalizedStringKey
    let background: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: width, height: 40)
                    .background(background)
                    .padding()
                Text(title)
                    .foregroundColor(.primary)
            }
        }
    }
}
