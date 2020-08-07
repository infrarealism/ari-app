import SwiftUI

struct Cta: View {
    let title: LocalizedStringKey
    let background: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .frame(width: width, height: 40)
            .background(background)
            .cornerRadius(20)
            .foregroundColor(.primary)
            .padding()
    }
}
