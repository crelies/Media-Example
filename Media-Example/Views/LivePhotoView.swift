//
//  LivePhotoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import Photos
import SwiftUI

struct LivePhotoView: View {
    let livePhoto: LivePhoto

    @State private var phLivePhoto: PHLivePhoto?
    @State private var error: Error?

    var body: some View {
        Group {
            #if os(macOS) || targetEnvironment(macCatalyst)
            Text("Live Photo objects are available only when editing Live Photo content in a photo editing extension that runs in the Photos app.")
                .padding(.horizontal)
            #else
            phLivePhoto.map { PhotosUILivePhotoView(phLivePhoto: $0) }
            #endif

            error.map { Text($0.localizedDescription) }
        }.onAppear {
            self.livePhoto.displayRepresentation(targetSize: CGSize(width: 400, height: 200)) { result in
                switch result {
                case .success(let phLivePhoto):
                    self.phLivePhoto = phLivePhoto
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
