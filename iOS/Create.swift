import SwiftUI

struct Create: View {
    weak var window: UIWindow!
    @State private var name = ""
    @State private var widths = [CGFloat(1), 0, 0]
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                First(widths: self.$widths, name: self.$name) {
                    self.window.endEditing(true)
                }.frame(width: geo.size.width * self.widths[0], height: geo.size.height)
                    .opacity(.init(self.widths[0]))
                Second(widths: self.$widths)
                    .frame(width: geo.size.width * self.widths[1], height: geo.size.height)
                    .opacity(.init(self.widths[1]))
                Third(widths: self.$widths)
                    .frame(width: geo.size.width * self.widths[2], height: geo.size.height)
                    .opacity(.init(self.widths[2]))
            }
        }
    }
}

private struct First: View {
    @Binding var widths: [CGFloat]
    @Binding var name: String
    var commit: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 220, height: 40)
                    .foregroundColor(.init(.secondarySystemBackground))
                HStack {
                    Spacer()
                    TextField("Website.name", text: $name, onCommit: commit)
                        .autocapitalization(.sentences)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 200, height: 40)
                    Spacer()
                }
            }
            Button(action: {
                withAnimation {
                    self.widths = [0, 1, 0]
                }
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding()
            }.foregroundColor(.pink)
                .padding(.vertical, 50)
        }
    }
}

private struct Second: View {
    @Binding var widths: [CGFloat]
    
    var body: some View {
        Text("World")
    }
}

private struct Third: View {
    @Binding var widths: [CGFloat]
    
    var body: some View {
        Text("World")
    }
}
