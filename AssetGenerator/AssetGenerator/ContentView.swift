//
//  ContentView.swift
//  AssetGenerator
//
//  Created by Jukshio Pro on 28/07/21.
//

import FileProvider
import Foundation
import SwiftUI

// MARK: - ContentView

struct ContentView: View, ImageManagerDelegate {
    @State var isDraged: Bool = false
    @State var imageURL: URL?
    @State var image: NSImage?
    @State var showGeneratedImages: Bool = false
    @State var generatedImages: [(name: String, image: NSImage)] = []
    @State var fileName: String = "new_file"
    var body: some View {
        VStack(spacing: 16.0) {
            ZStack {
                if image == nil {
                    DragAndDropView()
                } else {
                    LoadedImageView(image: image)
                }
            }
            .frame(minWidth: 365, idealWidth: 365, maxWidth: 365, minHeight: 365, idealHeight: 365, maxHeight: 365, alignment: .center)
            .onDrop(of: [kUTTypeFileURL as String], delegate: self)
            if showGeneratedImages {
                VStack {
                    GeneratedImagesView(generatedImages: [generatedImages[0].image, generatedImages[1].image, generatedImages[2].image])
                        .frame(width: 365)
                    optionsView()
                }.animation(.default)
            }
        }

        .padding()
    }

    private func optionsView() -> some View {
        HStack(spacing: 8.0) {
            Button("Save to Disk") {
                DispatchQueue.global().async {
                    let desktopURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
                    for i in generatedImages {
                        let destinationURL = desktopURL.appendingPathComponent("\(i.name).png")
                        let nsImage = i.image
                        if nsImage.pngWrite(to: destinationURL, options: .withoutOverwriting) {
                            print("File saved")
                        }
                    }
                }
            }

            Button("Clear") {
                image = nil
                generatedImages = []
                showGeneratedImages = false
                imageURL = nil
            }
        }
    }

    func didGeneratedImages(oneX: (name: String, image: NSImage), twoX: (name: String, image: NSImage), threeX: (name: String, image: NSImage)) {
        generatedImages.append(oneX)
        generatedImages.append(twoX)
        generatedImages.append(threeX)
        showGeneratedImages = true
    }

    func didFailed(with error: String) {
        print("Error")
    }
}

// MARK: DropDelegate

extension ContentView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        image = nil
        generatedImages = []
        showGeneratedImages = false
        imageURL = nil
        guard let itemProvider = info.itemProviders(for: [kUTTypeFileURL as String]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil) { item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else {
                print("Error")
                return
            }
            DispatchQueue.main.async {
                self.imageURL = url
                image = NSImage(contentsOf: url)
                fileName = url.lastPathComponent as String
                if let url = imageURL {
                    ImageManager.generateImages(from: url, delegate: self)
                }
            }
        }
        return true
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 400)
    }
}

