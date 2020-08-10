import SwiftUI
import Core
import Combine

struct TextView: UIViewRepresentable {
    weak var website: Website!
    @Binding var id: String
    let view = UITextView()
    @State private var sub: AnyCancellable?

    func makeCoordinator() -> Text {
        .init(view: self)
    }
    
    func makeUIView(context: Context) -> Text {
        sub = context.coordinator.text.publisher(for: \.text).map(update).debounce(for: .seconds(1.1), scheduler: DispatchQueue(label: "", qos: .utility))
        .sink(receiveValue: website.update)
        return context.coordinator
    }
    
    func updateUIView(_ uiView: Text, context: Context) {
        uiView.text.text = website.model.pages.first { $0.id == id }!.content
    }
    
    private func update(_ text: String) -> Page {
        website.model.pages.first { $0.id == id }!.content(text)
    }
}
