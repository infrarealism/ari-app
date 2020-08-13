import SwiftUI

extension Photo {
    struct Picker: UIViewControllerRepresentable {
        func makeCoordinator() -> Image {
            .init()
        }
        
        func makeUIViewController(context: Context) -> Image {
            context.coordinator
        }
        
        func updateUIViewController(_ uiViewController: Photo.Image, context: Context) {
            
        }
    }
    
    final class Image: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
    }
}
