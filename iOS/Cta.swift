import SwiftUI

struct Cta: View {
    let title: LocalizedStringKey
    let background: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: width, height: 30)
                    .foregroundColor(background)
                Text(title)
                    .font(Font.caption.bold())
                    .foregroundColor(.primary)
            }.frame(height: 50)
        }.accentColor(.clear)
    }
}
