//
//  LivePhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct LivePhotosView: View {
    let livePhotos: [LivePhoto]

    var body: some View {
        List(livePhotos.sorted(by: { ($0.metadata?.creationDate ?? Date()) < ($1.metadata?.creationDate ?? Date()) })) { livePhoto in
            NavigationLink(destination: LivePhotoView(livePhoto: livePhoto)) {
                if let creationDate = livePhoto.metadata?.creationDate {
                    Text(creationDate, style: .date)
                } else {
                    Text(livePhoto.id)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Live Photos", displayMode: .inline)
    }
}

struct LivePhotosView_Previews: PreviewProvider {
    static var previews: some View {
        LivePhotosView(livePhotos: [])
    }
}
