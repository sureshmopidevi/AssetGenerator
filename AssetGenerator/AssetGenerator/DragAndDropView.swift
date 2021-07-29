//
//  DragAndDropView.swift
//  AssetGenerator
//
//  Created by Jukshio Pro on 29/07/21.
//

import SwiftUI

// MARK: - DragAndDropView

struct DragAndDropView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 365, height: 365, alignment: .center)
                .foregroundColor(Color.init(.underPageBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, miterLimit: 14, dash: [10], dashPhase: 10))
                        .padding(10)
                )
                .cornerRadius(16)
                .padding()
            VStack(spacing: 16.0) {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 124, height: 112, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                VStack(spacing: 4.0) {
                    Text("Drag and drop image")
                        .font(.title)
                    Text("*Please add high resolution image")
                        .font(.footnote)
                }
            }
        }
    }
}

// MARK: - DragAndDropView_Previews

struct DragAndDropView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropView()
    }
}
