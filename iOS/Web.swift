import SwiftUI
import WebKit
import Core

struct Web: View {
    weak var website: Website!
    @State private var mode = 1
    
    var body: some View {
        NavigationView {
            WebView(url: website.url!.appendingPathComponent(Page.index.file), mode: $mode)
                .navigationBarTitle(.init(verbatim: website.model.name), displayMode: .inline)
                .navigationBarItems(trailing:
                    Picker("Appearance", selection: $mode, content: {
                        Text(verbatim: "Light")
                            .tag(0)
                        Text(verbatim: "Dark")
                            .tag(1)
                    }).pickerStyle(SegmentedPickerStyle()))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var mode: Int
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.load(.init(url: url))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.overrideUserInterfaceStyle = mode == 1 ? .dark : .light
    }
}
