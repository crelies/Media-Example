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
    @State private var isAddViewVisible = false
    @State private var isAddConfirmationViewVisible = false
    @State private var albumName = ""

    @State private var previousAddResult: Result<Void, Error>?

    let albums: [Album]

    var body: some View {
        List(albums) { album in
            album.localizedTitle.map { title in
                NavigationLink(destination: AlbumView(album: album)) {
                    Text(title)
                }
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
        }).alert(isPresented: $isAddConfirmationViewVisible) {
            switch previousAddResult {
            case .success:
                return Self.alert(title: "Success", message: "Album added")
            case .failure(let error):
                return Self.alert(title: "Failure", message: error.localizedDescription)
            case .none:
                return Self.alert(title: "Failure", message: "An unknown error occurred")
            }
        }
    }
}

extension AlbumsView {
    private static func alert(title: String, message: String) -> Alert {
        Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
    }
}

struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: [])
    }
}
