//
//  GeneratedImagesView.swift
//  AssetGenerator
//
//  Created by Jukshio Pro on 29/07/21.
//

import SwiftUI

// MARK: - GeneratedImagesView

struct GeneratedImagesView: View {
    @State var generatedImages: [NSImage]
    var body: some View {
        HStack {
            ForEach(generatedImages, id: \.self) { i in
                Image(nsImage: i)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120, alignment: .center)
            }
        }.padding(.horizontal)
    }
}

// MARK: - GeneratedImagesView_Previews

struct GeneratedImagesView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratedImagesView(generatedImages: [])
    }
}
