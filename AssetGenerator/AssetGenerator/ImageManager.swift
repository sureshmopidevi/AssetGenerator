//
//  ImageManager.swift
//  AssetGenerator
//
//  Created by Jukshio Pro on 28/07/21.
//

import AppKit
import Foundation

// MARK: - ImageManagerDelegate

protocol ImageManagerDelegate {
    func didGeneratedImages(oneX: (name: String, image: NSImage), twoX: (name: String, image: NSImage), threeX: (name: String, image: NSImage))
    func didFailed(with error: String)
}

// MARK: - ImageManager

class ImageManager {
    private init() {}
    var delegate: ImageManagerDelegate?
    static func generateImages(from original: URL, delegate: ImageManagerDelegate) {
        guard let threeXImage = NSImage(contentsOf: original) else { return }
        let fileName = original.deletingPathExtension().lastPathComponent as String
        let originalSize = threeXImage.size
        let height = originalSize.height
        let width = originalSize.width
        let twoX = CGSize(width: width * 2, height: height * 2)
        let oneX = CGSize(width: width * 3, height: height * 3)

        guard let oneXImage = threeXImage.resized(to: oneX) else { return }
        guard let twoXImage = threeXImage.resized(to: twoX) else { return }
        delegate.didGeneratedImages(oneX: (name: fileName, image: oneXImage), twoX: (name: "\(fileName)@2x", image: twoXImage), threeX: (name: "\(fileName)@3x", image: threeXImage))
    }
}

extension NSImage {
    fileprivate func resized(to newSize: NSSize) -> NSImage? {
        if let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
        ) {
            bitmapRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
            draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()

            let resizedImage = NSImage(size: newSize)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }

        return nil
    }

    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }

    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
