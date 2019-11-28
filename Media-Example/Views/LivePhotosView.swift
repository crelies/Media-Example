//
//  LivePhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import SwiftUI

struct LivePhotosView: View {
    let livePhotos: [LivePhoto]

    var body: some View {
        List(livePhotos) { livePhoto in
            NavigationLink(destination: LivePhotoView(livePhoto: livePhoto)) {
                Text(livePhoto.phAsset.localIdentifier)
            }
        }.navigationBarTitle("Live Photos", displayMode: .inline)
    }
}

struct LivePhotosView_Previews: PreviewProvider {
    static var previews: some View {
        LivePhotosView(livePhotos: [])
    }
}
