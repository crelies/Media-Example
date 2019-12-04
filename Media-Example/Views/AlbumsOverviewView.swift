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

    @FetchAssets(filter: [.duration(300)],
                 sortDescriptors: [ NSSortDescriptor(key: "creationDate", ascending: true) ])
    private var videos: [Video]

    @FetchAlbums(ofType: .smart)
    private var albums: [Album]

    var body: some View {
        NavigationView {
            if permissionGranted || Media.isAccessAllowed {
                List {
                    Section {
                        NavigationLink(destination: VideosView(videos: videos)) {
                            Text("@FetchAssets videos")
                        }
                        NavigationLink(destination: AlbumsView(albums: albums)) {
                            Text("@FetchAlbums smart")
                        }
                    }

                    Section {
                        NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                            Text("\(userAlbums.count) User albums")
                        }
                        NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                            Text("\(cloudAlbums.count) Cloud albums")
                        }
                        NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                            Text("\(smartAlbums.count) Smart albums")
                        }
                    }

                    Section {
                        NavigationLink(destination: AudiosView(audios: Audios.all)) {
                            Text("Audios.all")
                        }
                        NavigationLink(destination: LivePhotosView(livePhotos: LivePhotos.all)) {
                            Text("LivePhotos.all")
                        }
                    }

                    Section {
                        NavigationLink(destination: PhotosView(photos: Media.Photos.all)) {
                            Text("Media.Photos.all")
                        }
                        NavigationLink(destination: PhotosView(photos: Media.Photos.depthEffect)) {
                            Text("Photos.depthEffect")
                        }
                        NavigationLink(destination: PhotosView(photos: Media.Photos.hdr)) {
                            Text("Photos.hdr")
                        }
                        NavigationLink(destination: PhotosView(photos: Media.Photos.panorama)) {
                            Text("Photos.panorama")
                        }
                        NavigationLink(destination: PhotosView(photos: Media.Photos.screenshot)) {
                            Text("Photos.screenshot")
                        }
                    }

                    Section {
                        NavigationLink(destination: VideosView(videos: Videos.all)) {
                            Text("Videos.all")
                        }
                        NavigationLink(destination: VideosView(videos: Videos.highFrameRates)) {
                            Text("Videos.highFrameRates")
                        }
                        NavigationLink(destination: VideosView(videos: Videos.streams)) {
                            Text("Videos.streams")
                        }
                        NavigationLink(destination: VideosView(videos: Videos.timelapses)) {
                            Text("Videos.timelapses")
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

                        #if !targetEnvironment(macCatalyst)
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
                        #endif

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
                .navigationBarTitle("Examples")
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
