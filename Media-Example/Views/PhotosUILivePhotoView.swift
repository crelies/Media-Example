//
//  PhotosUILivePhotoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import PhotosUI
import SwiftUI

struct PhotosUILivePhotoView: UIViewRepresentable {
    let phLivePhoto: PHLivePhoto

    func makeUIView(context: UIViewRepresentableContext<PhotosUILivePhotoView>) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = phLivePhoto
        return livePhotoView
    }

    func updateUIView(_ uiView: PHLivePhotoView, context: UIViewRepresentableContext<PhotosUILivePhotoView>) {

    }
}
