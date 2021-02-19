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

struct AlbumsView: View {
    @State private var isAddViewVisible = false
    @State private var indexSetToDelete: IndexSet?

    let albums: [Album]

    var body: some View {
        List {
            ForEach(albums.sorted(by: { ($0.localizedTitle ?? String()) < ($1.localizedTitle ?? String()) })) { album in
                NavigationLink(destination: AlbumView(album: album)) {
                    if let localizedTitle = album.localizedTitle {
                        Text(localizedTitle)
                    } else {
                        Text(album.id)
                    }
                }
            }
            .onDelete { indexSet in
                indexSetToDelete = indexSet
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
    }
}

private extension AlbumsView {
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

struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: [])
    }
}
