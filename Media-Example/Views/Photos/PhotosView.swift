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
        List(photos.sorted(by: { ($0.metadata?.creationDate ?? Date()) < ($1.metadata?.creationDate ?? Date()) })) { photo in
            NavigationLink(destination: PhotoView(photo: photo)) {
                if let creationDate = photo.metadata?.creationDate {
                    Text(creationDate, style: .date)
                } else {
                    Text(photo.id)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Photos", displayMode: .inline)
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView(photos: [])
    }
}
