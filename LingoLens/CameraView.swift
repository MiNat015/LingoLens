//
//  CameraView.swift
//  LingoLens
//
//  Created by Arjun Srikanth on 26/8/2024.
//

import Foundation
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        viewController.cameraDevice = .rear
        viewController.cameraOverlayView = .none
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
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
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            return image.imageResized(to: targetSize)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) 
        {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print("Image Taken")
                print("Width: " + image.size.width.description)
                print("Height: " + image.size.height.description)
                
                self.parent.image = image.imageResized(to: CGSize(width: 3000, height:2250))
            }
        }
    }
}

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
