import SwiftUI

struct Create: View {
    weak var window: UIWindow!
    @State private var offset = CGFloat()
    @State private var name = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    First(offset: self.$offset, name: self.$name, window: self.window)
                        .frame(width: geo.size.width, height: geo.size.height)
                    Circle()
                        .frame(width: geo.size.width, height: geo.size.height)
                    Rectangle()
                        .frame(width: geo.size.width, height: geo.size.height)
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .offset(x: geo.size.width * -self.offset)
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        Button(action: {
                            self.window.endEditing(true)
                            withAnimation {
                                self.offset -= 1
                            }
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding()
                        }.foregroundColor(.pink)
                            .disabled(self.offset == 0)
                            .opacity(self.offset == 0 ? 0.4 : 1)
                        Button(action: {
                            self.window.endEditing(true)
                            withAnimation {
                                self.offset += 1
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding()
                        }.foregroundColor(.pink)
                            .disabled(self.offset == 2)
                            .opacity(self.offset == 2 ? 0.4 : 1)
                    }
                    Button(action: {
                        self.window.rootViewController!.dismiss(animated: true)
                    }) {
                        Text("Cancel")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }.foregroundColor(.pink)
                        .frame(height: 50)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

private struct First: View {
    @Binding var offset: CGFloat
    @Binding var name: String
    weak var window: UIWindow!
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 220, height: 40)
                    .foregroundColor(.init(.secondarySystemBackground))
                HStack {
                    Spacer()
                    TextField("Website.name", text: $name) {
                        self.window.endEditing(true)
                    }.autocapitalization(.sentences)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 200, height: 40)
                    Spacer()
                }
            }
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
