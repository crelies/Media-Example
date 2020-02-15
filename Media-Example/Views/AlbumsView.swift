//
//  AlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AlbumsView: View {
    @State private var isAddViewVisible = false
    @State private var isAddConfirmationViewVisible = false
    @State private var isDeleteViewVisible = false
    @State private var albumName = ""

    @State private var previousAddResult: Result<Void, Error>?
    @State private var indexSetToDelete: IndexSet = IndexSet()

    let albums: [Album]

    var body: some View {
        List {
            ForEach(albums) { album in
                album.localizedTitle.map { title in
                    NavigationLink(destination: AlbumView(album: album)) {
                        Text(title)
                    }
                }
            }.onDelete { indexSet in
                self.indexSetToDelete = indexSet
                self.isDeleteViewVisible = true
            }
        }.navigationBarTitle(Text("Album list"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.previousAddResult = nil
            self.albumName = ""
            self.isAddViewVisible = true
        }) {
            Text("Add")
        }.sheet(isPresented: $isAddViewVisible, onDismiss: {
            self.isAddViewVisible = false

            if self.previousAddResult != nil {
                self.isAddConfirmationViewVisible = true
            }
        }) {
            NavigationView {
                Form {
                    TextField("Album name", text: self.$albumName)

                    Button(action: {
                        if self.albumName.count > 3 {
                            Album.create(title: self.albumName) { result in
                                self.previousAddResult = result
                                self.isAddViewVisible = false
                            }
                        }
                    }) {
                        Text("Create")
                    }
                }.navigationBarItems(trailing: Button(action: {
                    self.isAddViewVisible = false
                }) {
                    Image(systemName: "xmark")
                })
            }.navigationViewStyle(StackNavigationViewStyle())
        })
        .alert(isPresented: $isAddConfirmationViewVisible) {
            switch previousAddResult {
            case .success:
                return Self.alert(title: "Success", message: "Album added")
            case .failure(let error):
                return Self.alert(title: "Failure", message: error.localizedDescription)
            case .none:
                return Self.alert(title: "Failure", message: "An unknown error occurred")
            }
        }
        .alert(isPresented: $isDeleteViewVisible) {
            self.deleteConfirmationAlert(indexSetToDelete: self.indexSetToDelete)
        }
    }
}

extension AlbumsView {
    private static func alert(title: String, message: String) -> Alert {
        Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
    }

    private func deleteConfirmationAlert(indexSetToDelete: IndexSet) -> Alert {
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
                self.indexSetToDelete = IndexSet()
                self.isDeleteViewVisible = false
                return
            }

            albumsToDelete.forEach { $0.delete { _ in } }

            self.indexSetToDelete = IndexSet()
            self.isDeleteViewVisible = false
        }, secondaryButton: .cancel() {
            self.isDeleteViewVisible = false
        })
    }
}

struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: [])
    }
}
