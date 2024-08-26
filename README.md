# LingoLens

## Author
Arjun Srikanth (Final Year Student of Computer Science)

## Description
LingoLens is a mobile application designed to help users translate English text found in the real world into their native language. The app utilizes computer vision to detect and recognize text from images captured using the device's camera. The recognized text can then be translated into the user's desired language.

## Features

- **Text Recognition:** Capture images using your device's camera, and the app will automatically recognize and extract text using the Vision framework.
- **Text Translation:** Translate recognized text into your native language using a simple and intuitive interface.
- **Retake Images:** Easily retake images if the captured photo is not satisfactory.
- **Resizing Images:** The app automatically resizes images to optimize text recognition performance.

## Getting Started

### Prerequisites

- iOS 14.0 or later
- Xcode 12.0 or later

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/username/lingolens.git
   ```
2. Open the project in XCode

   ```bash
   cd lingolens
   open LingoLens.xcodeproj
   ```

3. Build and run the app on your device

### Usage

1. Open the LingoLens app on your device.
2. Allow camera access when prompted.
3. Capture an image of the text you wish to translate.
4. Wait for the app to recognize the text.
5. Tap on the "Translate" button to view the translation.

### Code Overview

`ContentView.swift`
- The main content view that handles camera access, image display, text recognition, and translation presentation.
- recogniseText: Uses the Vision framework to recognize text from the captured image.
- pictureTakenView: Displays the captured image and recognized texts with an option to translate.

`CameraView.swift`
- A UIViewControllerRepresentable that wraps the UIImagePickerController for capturing images.
- Handles image resizing and passing the image back to ContentView.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
