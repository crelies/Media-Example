//
//  VideosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import SwiftUI

struct VideosView: View {
    let videos: [Video]

    var body: some View {
        List(videos) { video in
            NavigationLink(destination: VideoView(video: video)) {
                Text(video.phAsset.localIdentifier)
            }
        }.navigationBarTitle("Videos", displayMode: .inline)
    }
}

struct VideosView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView(videos: [])
    }
}
