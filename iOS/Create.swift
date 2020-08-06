import SwiftUI

struct Create: View {
    weak var window: UIWindow!
    @State private var offset = CGFloat()
    @State private var name = ""
    @State private var mode = 0
    
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
                                    .frame(width: CGFloat(200) / 3 * (self.offset + 1))
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
                    First(name: self.$name, window: self.window)
                        .frame(width: geo.size.width, height: geo.size.height)
                    Second(mode: self.$mode)
                        .frame(width: geo.size.width, height: geo.size.height)
                    Circle()
                        .frame(width: geo.size.width, height: geo.size.height)
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .offset(x: geo.size.width * -self.offset)
            }
        }
    }
}

private struct First: View {
    @Binding var name: String
    weak var window: UIWindow!
    
    var body: some View {
        VStack {
            Text("Enter.name")
                .foregroundColor(.secondary)
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
    @Binding var mode: Int
    @State private var blog = false
    @State private var store = false
    
    var body: some View {
        VStack {
            Text("Enter.type")
                .foregroundColor(.secondary)
            HStack {
                Segment(selected: mode == 0, image: "dot.square", name: "Single") {
                    withAnimation {
                        self.mode = 0
                    }
                }
                if blog {
                    Segment(selected: mode == 1, image: "square.stack.3d.up", name: "Blog") {
                        withAnimation {
                            self.mode = 1
                        }
                    }
                } else {
                    Perk(image: "square.stack.3d.up", name: "Blog") {
                        self.store = true
                    }
                }
            }.sheet(isPresented: $store) {
                Store(display: self.$store)
            }
        }.onReceive(session.user) { user in
            withAnimation {
                self.blog = user.purchases.contains(.blog)
            }
        }
    }
}

private struct Third: View {
    @Binding var widths: [CGFloat]
    
    var body: some View {
        Text("World")
    }
}

private struct Segment: View {
    let selected: Bool
    let image: String
    let name: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(selected ? .pink : .clear)
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Text(name)
                    .foregroundColor(selected ? .primary : .secondary)
                    .font(Font.caption.bold())
                Text("")
                    .font(Font.caption.bold())
            }
        }.accentColor(selected ? .black : .pink)
            .padding()
    }
}

private struct Perk: View {
    let image: String
    let name: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.clear)
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                Text(name)
                    .foregroundColor(.secondary)
                    .font(Font.caption.bold())
                Text("In.app")
                    .foregroundColor(.secondary)
                    .font(Font.caption.bold())
            }
        }.accentColor(.init(.systemIndigo))
            .padding()
    }
}
