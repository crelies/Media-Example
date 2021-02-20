//
//  Item.swift
//  Media-Example
//
//  Created by Christian Elies on 20.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct ItemMetadata: Hashable, Identifiable {
    let id: String
}

struct AlbumMetadata: Hashable, Identifiable {
    let id: String
    let localizedTitle: String

    let audios: [String]
    let livePhotos: [String]
    let photos: [String]
    let videos: [String]
}

enum Item: Hashable, Identifiable {
    var id: Self { self }

    case albums(items: [Item])
    case album(album: AlbumMetadata)

    case audios(items: [Item])
    case audio(audio: ItemMetadata)

    case livePhotos(items: [Item])
    case livePhoto(livePhoto: ItemMetadata)

    case photos(items: [Item])
    case photo(photo: ItemMetadata)

    case videos(items: [Item])
    case video(video: ItemMetadata)

    var children: [Item]? {
        switch self {
        case let .albums(items):
            return items
        case let .album(album):
            return [
                .audios(items: album.audios.map { Item.audio(audio: .init(id: $0)) }),
                .livePhotos(items: album.livePhotos.map { Item.livePhoto(livePhoto: .init(id: $0)) }),
                .photos(items: album.photos.map { Item.photo(photo: .init(id: $0)) }),
                .videos(items: album.videos.map { Item.video(video: .init(id: $0)) })
            ].filter { !($0.children?.isEmpty ?? true) }
        case let .audios(items):
            return !items.isEmpty ? items : nil
        case let .livePhotos(items):
            return !items.isEmpty ? items : nil
        case let .photos(items):
            return !items.isEmpty ? items : nil
        case let .videos(items):
            return !items.isEmpty ? items : nil
        default:
            return nil
        }
    }

    @ViewBuilder func view<DetailView: View>(@ViewBuilder detailView: @escaping (String) -> DetailView) -> some View {
        switch self {
        case let .albums(items):
            Text("Albums") + Text(" (\(items.count))").font(.footnote)
        case let .album(album):
            let mediaCount = album.audios.count + album.livePhotos.count + album.photos.count + album.videos.count
            Text(album.localizedTitle) + Text("\n") + Text("\(mediaCount) media items").font(.footnote)
        case let .audios(items):
            Text("Audios") + Text(" (\(items.count))").font(.footnote)
        case let .audio(audio):
            Text(audio.id)
        case let .livePhotos(items):
            Text("Live Photos") + Text(" (\(items.count))").font(.footnote)
        case let .livePhoto(livePhoto):
            NavigationLink(destination: detailView(livePhoto.id)) {
                Text(livePhoto.id)
            }
        case let .photos(items):
            Text("Photos") + Text(" (\(items.count))").font(.footnote)
        case let .photo(photo):
            NavigationLink(destination: detailView(photo.id)) {
                Text(photo.id)
            }
        case let .videos(items):
            Text("Videos") + Text(" (\(items.count))").font(.footnote)
        case let .video(video):
            NavigationLink(destination: detailView(video.id)) {
                Text(video.id)
            }
        }
    }
}
