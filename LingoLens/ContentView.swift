//
//  ContentView.swift
//  LingoLens
//
//  Created by Arjun Srikanth on 26/8/2024.
//

import SwiftUI
import Vision
import Translation

// View to display the recognized text with an option to translate it
struct TranslationView : View {
    let text : String
    @State private var showTranslation = false
    
    var body: some View {
        HStack {
            Text(text) // Display recognized text
            Spacer()
            // Menu button to trigger translation
            Menu {
                Button {
                    showTranslation = true
                } label: {
                    Text("Translate")
                }
            } label: {
                Label("", systemImage: "ellipsis.circle")
            }
            .foregroundColor(Color.accentColor)
            .menuStyle(.button)
        }
        // Present translation overlay
        .translationPresentation(isPresented: $showTranslation, text: text)
    }
}

// Main content view
struct ContentView: View {
    @State private var cameraOpen = false
    @State private var imageTaken : UIImage?
    @State private var recognisedTexts = [String]()
    @State private var isLoading = false
    
    // Function to recognize text in the captured image using Vision framework
    func recogniseText() {
        print("Reading Text")
        let requestHandler = VNImageRequestHandler(cgImage: self.imageTaken!.cgImage!)
        
        // Request to recognize text
        let recognizeTextRequest = VNRecognizeTextRequest {(request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return
            }
            
            // Extract the recognized text and store it
            for observation in observations {
                let recognizedText = observation.topCandidates(1).first!.string
                self.recognisedTexts.append(recognizedText)
            }
        }
        
        // Perform text recognition in a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([recognizeTextRequest])
                self.isLoading = false
            }
            catch {
                print(error)
            }
        }
    }
    
    // View for dispaying the picture taken and recognized texts
    var pictureTakenView: some View {
        VStack {
            // Display the image taken
            Image(uiImage: self.imageTaken!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            // Re-take the image
            Button(action: {
                self.imageTaken = nil
                self.recognisedTexts = [String]()
            }, label: {
                HStack {
                    Image(systemName: "camera")
                    Text("Re-take picture")
                }
            })
            // List of recognized texts with translation options
            List {
                ForEach(self.recognisedTexts, id: \.self) {
                    TranslationView(text: "\($0)")
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if (self.imageTaken == nil) {
                // Show camera view if no image is taken
                CameraView(image: self.$imageTaken)
            } else {
                if (!self.isLoading) {
                    self.pictureTakenView
                        .onAppear {
                            // Start recognition once the image is taken
                            self.recogniseText()
                        }
                } else {
                    // Show loading indicator while recognizing text
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
