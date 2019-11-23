//
//  AlbumsOverviewView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import SwiftUI

struct AlbumsOverviewView: View {
    @State private var userAlbums: [Album] = []
    @State private var cloudAlbums: [Album] = []
    @State private var smartAlbums: [Album] = []

    @State private var permissionGranted: Bool = false
    @State private var permissionError: PermissionError?

    var body: some View {
        NavigationView {
            if permissionGranted {
                List {
                    Section {
                        NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                            Text("\(userAlbums.count) User albums")
                        }
                    }

                    Section {
                        NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                            Text("\(cloudAlbums.count) Cloud albums")
                        }
                    }

                    Section {
                        NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                            Text("\(smartAlbums.count) Smart albums")
                        }
                    }
                }.listStyle(GroupedListStyle())
            } else {
                VStack(spacing: 20) {
                    self.permissionError.map { Text($0.localizedDescription) }

                    Button(action: {
                        self.requestPermission()
                    }) {
                        Text("Trigger permission request")
                    }
                }
            }
        }.onAppear {

        }
    }
}

extension AlbumsOverviewView {
    private func requestPermission() {
        Media.requestPermission { result in
            switch result {
            case .success:
                self.permissionGranted = true
                self.permissionError = nil
                self.userAlbums = Albums.user
                self.cloudAlbums = Albums.cloud
                self.smartAlbums = Albums.smart
            case .failure(let error):
                self.permissionGranted = false
                self.permissionError = error
            }
        }
    }
}

struct AlbumsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsOverviewView()
    }
}
