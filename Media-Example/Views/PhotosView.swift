//
//  PhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotosView: View {
    let photos: [Photo]

    var body: some View {
        List(photos) { photo in
            NavigationLink(destination: PhotoView(photo: photo)) {
                Text(photo.id)
            }
        }.navigationBarTitle("Photos", displayMode: .inline)
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView(photos: [])
    }
}
