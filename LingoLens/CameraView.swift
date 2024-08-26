//
//  CameraView.swift
//  LingoLens
//
//  Created by Arjun Srikanth on 26/8/2024.
//

import Foundation
import SwiftUI
import UIKit

// UIViewControllerRepresentable to manage UIImagePickerController for taking pictures
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    typealias UIViewControllerType = UIImagePickerController
    
    // Create and configure UIImagePickerController
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        viewController.cameraDevice = .rear
        viewController.cameraOverlayView = .none
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    // Coordinator to handle UIImagePickerController delegate methods
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
    
}

extension CameraView {
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        var parent : CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        // Handle cancel action in image picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        // Resize the captured image to the target size
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            return image.imageResized(to: targetSize)
        }
        
        // Handle the image after it has been picked
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print("Image Taken")
                print("Width: " + image.size.width.description)
                print("Height: " + image.size.height.description)
                
                // Resize the image and store it in the binding
                self.parent.image = image.imageResized(to: CGSize(width: 3000, height:2250))
            }
        }
    }
}

extension UIImage {
    // Helper method to resize a given UIImage
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
