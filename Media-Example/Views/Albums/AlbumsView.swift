//
//  AlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

extension IndexSet: Identifiable {
    public var id: Self { self }
}

enum ViewState<T: Hashable> {
    case loading
    case loaded(value: T)
    case failed(error: Swift.Error)
}

struct AlbumsView: View {
    @State private var viewState: ViewState<Item> = .loading
    @State private var isAddViewVisible = false
    @State private var indexSetToDelete: IndexSet?

    let albums: [Album]

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView("Fetching media from \(albums.count) albums ...")
                .onAppear(perform: load)
        case let .loaded(item):
            List {
                OutlineGroup(item, children: \.children) { item in
                    item.view { _ in }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Albums"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isAddViewVisible = true
            }) {
                Text("Add")
            }
            .sheet(isPresented: $isAddViewVisible, onDismiss: {
                isAddViewVisible = false
            }) {
                AddAlbumScreen()
            })
            .alert(item: $indexSetToDelete) { indexSet in
                deleteConfirmationAlert(indexSetToDelete: indexSet)
            }
        case let .failed(error):
            Text(error.localizedDescription)
        }

//            ForEach(albums.sorted(by: { ($0.localizedTitle ?? String()) < ($1.localizedTitle ?? String()) })) { album in
//                NavigationLink(destination: AlbumView(album: album)) {
//                    if let localizedTitle = album.localizedTitle {
//                        Text(localizedTitle)
//                    } else {
//                        Text(album.id)
//                    }
//                }
//            }
//            .onDelete { indexSet in
//                indexSetToDelete = indexSet
//            }
    }
}

private extension AlbumsView {
    func load() {
        DispatchQueue.global(qos: .userInitiated).async {
            let item = Item.albums(
                items: albums.map { album -> Item in
                    let albumMetadata = AlbumMetadata(
                        id: album.id,
                        localizedTitle: album.localizedTitle ?? "Album",
                        audios: album.audios.map { $0.id },
                        livePhotos: album.livePhotos.map { $0.id },
                        photos: album.photos.map { $0.id },
                        videos: album.videos.map { $0.id }
                    )
                    return Item.album(album: albumMetadata)
                }
            )
            DispatchQueue.main.async {
                viewState = .loaded(value: item)
            }
        }
    }

    func deleteConfirmationAlert(indexSetToDelete: IndexSet) -> Alert {
        var albumsToDelete: [Album] = []
        for index in indexSetToDelete {
            guard index >= 0, index < albums.count else {
                continue
            }

            let album = albums[index]
            albumsToDelete.append(album)
        }

        let albumsToDeleteSummary = albumsToDelete.map { $0.localizedTitle ?? "Unknown title" }.joined(separator: ", ")

        return Alert(title: Text("Are you sure?"), message: Text("[\(albumsToDeleteSummary)] will be deleted"), primaryButton: .default(Text("Yes")) {
            guard !albumsToDelete.isEmpty else {
                self.indexSetToDelete = nil
                return
            }

            albumsToDelete.forEach { $0.delete { _ in } }

            self.indexSetToDelete = nil
        }, secondaryButton: .cancel() {
            self.indexSetToDelete = nil
        })
    }
}

#if DEBUG
struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: [])
    }
}
#endif
