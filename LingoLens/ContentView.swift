//
//  ContentView.swift
//  LingoLens
//
//  Created by Arjun Srikanth on 26/8/2024.
//

import SwiftUI
import Vision

struct ContentView: View {
    @State private var cameraOpen = false
    @State private var imageTaken : UIImage?
    @State private var recognisedTexts = [String]()
    @State private var isLoading = false
    
    func recogniseText() {
        print("Reading Text")
        let requestHandler = VNImageRequestHandler(cgImage: self.imageTaken!.cgImage!)
        
        let recognizeTextRequest = VNRecognizeTextRequest {(request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return
            }
            
            for observation in observations {
                let recognizedText = observation.topCandidates(1).first!.string
                self.recognisedTexts.append(recognizedText)
            }
        }
        
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
    
    var pictureTakenView: some View {
        VStack {
            Image(uiImage: self.imageTaken!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Button(action: {
                self.imageTaken = nil
                self.recognisedTexts = [String]()
            }, label: {
                HStack {
                    Image(systemName: "camera")
                    Text("Re-take picture")
                }
            })
            List {
                ForEach(self.recognisedTexts, id: \.self) {
                    Text("\($0)")
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if (self.imageTaken == nil) {
                CameraView(image: self.$imageTaken)
            } else {
                if (!self.isLoading) {
                    self.pictureTakenView
                        .onAppear {
                            self.recogniseText()
                        }
                } else {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
