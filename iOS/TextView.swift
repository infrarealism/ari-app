import SwiftUI
import Combine
import Core

struct TextView: UIViewRepresentable {
    weak var website: Website!
    weak var insert: PassthroughSubject<String, Never>!
    weak var selected: CurrentValueSubject<String, Never>!
    @Binding var id: String

    func makeCoordinator() -> Coordinator {
        .init(website: website, insert: insert, selected: selected, view: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) {
        if uiView.id != id {
            uiView.id = id
        }
    }
}
