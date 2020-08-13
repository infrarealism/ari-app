import SwiftUI
import Photos

extension Photo {
    struct Picker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        @Binding var name: String
        @Binding var display: Bool
        
        func makeCoordinator() -> Coordinator {
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                PHPhotoLibrary.requestAuthorization { _ in }
            }
            
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
