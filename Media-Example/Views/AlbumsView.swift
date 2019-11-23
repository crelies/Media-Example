//
//  AlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import SwiftUI

struct AlbumsView: View {
    let albums: [Album]

    var body: some View {
        List(albums) { album in
            album.localizedTitle.map { title in
                NavigationLink(destination: AlbumView(album: album)) {
                    Text(title)
                }
            }
        }.navigationBarTitle(Text("Album list"), displayMode: .inline)
    }
}

struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: [])
    }
}
