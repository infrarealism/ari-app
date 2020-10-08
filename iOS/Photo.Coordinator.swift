import UIKit
import Photos

extension Photo {
    final class Coordinator: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: Picker!
        
        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            picker.display = false
        }
        
        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey : Any]) {
            guard PHPhotoLibrary.authorizationStatus() != .notDetermined else { return }
            didFinishPickingMediaWithInfo[.originalImage].flatMap { $0 as? UIImage }.map {
                picker.name = PHAssetResource.assetResources(for: didFinishPickingMediaWithInfo[.phAsset] as! PHAsset).first!.originalFilename
                self.picker.image = $0
                self.picker.display = false
            }
        }
    }
}
