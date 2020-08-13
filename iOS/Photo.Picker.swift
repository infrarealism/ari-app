import SwiftUI

extension Photo {
    struct Picker: UIViewControllerRepresentable {
        func makeCoordinator() -> Coordinator {
            let coordinator = Coordinator()
            coordinator.picker = self
            coordinator.delegate = coordinator
            return coordinator
        }
        
        func makeUIViewController(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIViewController(_ uiViewController: Coordinator, context: Context) {
            
        }
    }
}
