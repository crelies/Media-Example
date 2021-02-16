//
//  AlbumView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AlbumView: View {
    let album: Album

    var body: some View {
        VStack(spacing: 0) {
            Text("\(album.allMedia.count) media items").font(.footnote).padding(.vertical)

            List {
                Section {
                    NavigationLink(destination: AudiosView(audios: album.audios)) {
                        Text("\(album.audios.count) audios")
                    }
                }

                Section {
                    NavigationLink(destination: LivePhotosView(livePhotos: album.livePhotos)) {
                        Text("\(album.livePhotos.count) live photos")
                    }
                }

                Section {
                    NavigationLink(destination: PhotosView(photos: album.photos)) {
                        Text("\(album.photos.count) photos")
                    }
                }

                Section {
                    NavigationLink(destination: PhotoGridView(photos: album.photos)) {
                        Text("Photo GridView")
                    }
                }

                Section {
                    NavigationLink(destination: VideosView(videos: album.videos)) {
                        Text("\(album.videos.count) videos")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle(Text(album.localizedTitle ?? ""), displayMode: .inline)
    }
}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
