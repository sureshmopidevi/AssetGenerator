//
//  ImageView.swift
//  AssetGenerator
//
//  Created by Jukshio Pro on 29/07/21.
//

import SwiftUI

struct LoadedImageView: View {
    @State var image:NSImage?
    var body: some View {
        VStack {
            Image(nsImage: image ?? NSImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(minWidth: 365, idealWidth: 365, maxWidth: 365, minHeight: 365, idealHeight: 365, maxHeight: 365, alignment: .center)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadedImageView()
    }
}
