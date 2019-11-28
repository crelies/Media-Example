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

    @State private var isCameraViewVisible = false
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isLivePhotoCameraViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isPhotoCameraViewVisible = false
    @State private var isVideoBrowserViewVisible = false
    @State private var isVideoCameraViewVisible = false

    var body: some View {
        NavigationView {
            if permissionGranted || Media.isAccessAllowed {
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

                    Section {
                        Button(action: {
                            self.isCameraViewVisible = true
                        }) {
                            Text("Camera.view")
                        }.sheet(isPresented: $isCameraViewVisible, onDismiss: {
                            self.isCameraViewVisible = false
                        }) {
                            try? Camera.view { result in

                            }
                        }

                        Button(action: {
                            self.isLivePhotoCameraViewVisible = true
                        }) {
                            Text("LivePhoto.camera")
                        }.sheet(isPresented: $isLivePhotoCameraViewVisible, onDismiss: {
                            self.isLivePhotoCameraViewVisible = false
                        }) {
                            try? LivePhoto.camera { result in

                            }
                        }

                        Button(action: {
                            self.isPhotoCameraViewVisible = true
                        }) {
                            Text("Photo.camera")
                        }.sheet(isPresented: $isPhotoCameraViewVisible, onDismiss: {
                            self.isPhotoCameraViewVisible = false
                        }) {
                            try? Photo.camera { result in

                            }
                        }

                        Button(action: {
                            self.isVideoCameraViewVisible = true
                        }) {
                            Text("Video.camera")
                        }.sheet(isPresented: $isVideoCameraViewVisible, onDismiss: {
                            self.isVideoCameraViewVisible = false
                        }) {
                            try? Video.camera { result in

                            }
                        }
                    }

                    Section {
                        Button(action: {
                            self.isLivePhotoBrowserViewVisible = true
                        }) {
                            Text("LivePhoto.browser")
                        }.sheet(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                            self.isLivePhotoBrowserViewVisible = false
                        }) {
                            try? LivePhoto.browser { result in

                            }
                        }

                        Button(action: {
                            self.isMediaBrowserViewVisible = true
                        }) {
                            Text("Media.browser")
                        }.sheet(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                            self.isMediaBrowserViewVisible = false
                        }) {
                            try? Media.browser { result in

                            }
                        }

                        Button(action: {
                            self.isPhotoBrowserViewVisible = true
                        }) {
                            Text("Photo.browser")
                        }.sheet(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                            self.isPhotoBrowserViewVisible = false
                        }) {
                            try? Photo.browser { result in

                            }
                        }

                        Button(action: {
                            self.isVideoBrowserViewVisible = true
                        }) {
                            Text("Video.browser")
                        }.sheet(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                            self.isVideoBrowserViewVisible = false
                        }) {
                            try? Video.browser { result in

                            }
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
            if !Media.isAccessAllowed {
                self.requestPermission()
            } else {
                self.userAlbums = Albums.user
                self.cloudAlbums = Albums.cloud
                self.smartAlbums = Albums.smart
            }
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
