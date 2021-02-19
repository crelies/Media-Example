//
//  VideosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct VideosView: View {
    let videos: [Video]

    var body: some View {
        List(videos.sorted(by: { ($0.metadata?.creationDate ?? Date()) < ($1.metadata?.creationDate ?? Date()) })) { video in
            NavigationLink(destination: VideoView(video: video)) {
                if let creationDate = video.metadata?.creationDate {
                    Text(creationDate, style: .date)
                } else {
                    Text(video.id)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Videos", displayMode: .inline)
    }
}

struct VideosView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView(videos: [])
    }
}
