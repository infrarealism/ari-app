import SwiftUI

struct Create: View {
    weak var window: UIWindow!
    @State private var offset = CGFloat()
    @State private var name = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 4)
                                .foregroundColor(.init(.secondarySystemBackground))
                                .frame(width: 200)
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(height: 6)
                                    .foregroundColor(.pink)
                                    .frame(width: CGFloat(200) / 3 * self.offset)
                                        Spacer()
                                Spacer()
                            }
                        }.frame(width: 200)
                            .padding(.top, 10)
                        Spacer()
                    }
                    Text("New.website")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
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
                HStack(spacing: 0) {
                    First(offset: self.$offset, name: self.$name, window: self.window)
                        .frame(width: geo.size.width, height: geo.size.height)
                    Circle()
                        .frame(width: geo.size.width, height: geo.size.height)
                    Rectangle()
                        .frame(width: geo.size.width, height: geo.size.height)
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .offset(x: geo.size.width * -self.offset)
            }
        }
    }
}

private struct First: View {
    @Binding var offset: CGFloat
    @Binding var name: String
    weak var window: UIWindow!
    
    var body: some View {
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
