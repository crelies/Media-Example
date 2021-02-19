//
//  RootScreen.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import MediaSwiftUI
import SwiftUI

struct RootScreen: View {
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

    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: true)])
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
                    }

                    Section {
                        NavigationLink(destination: PhotosView(photos: Media.Photos.all)) {
                            Text("Media.Photos.all")
                        }
                        NavigationLink(destination: LivePhotosView(livePhotos: Media.Photos.live)) {
                            Text("Media.Photos.live")
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
                        }
                        .fullScreenCover(isPresented: $isCameraViewVisible, onDismiss: {
                            self.isCameraViewVisible = false
                        }) {
                            try? Camera.view { _ in }
                        }

                        #if !targetEnvironment(macCatalyst)
                        Button(action: {
                            self.isLivePhotoCameraViewVisible = true
                        }) {
                            Text("LivePhoto.camera")
                        }
                        .fullScreenCover(isPresented: $isLivePhotoCameraViewVisible, onDismiss: {
                            self.isLivePhotoCameraViewVisible = false
                        }) {
                            try? LivePhoto.camera { result in
                                guard let livePhotoData = try? result.get() else {
                                    return
                                }

                                try? LivePhoto.save(data: livePhotoData) { result in
                                    switch result {
                                    case .failure(let error):
                                        debugPrint("Live photo save error: \(error)")
                                    default: ()
                                    }
                                }
                            }
                        }
                        #endif

                        Button(action: {
                            self.isPhotoCameraViewVisible = true
                        }) {
                            Text("Photo.camera")
                        }
                        .fullScreenCover(isPresented: $isPhotoCameraViewVisible, onDismiss: {
                            self.isPhotoCameraViewVisible = false
                        }) {
                            try? Photo.camera { _ in }
                        }

                        Button(action: {
                            self.isVideoCameraViewVisible = true
                        }) {
                            Text("Video.camera")
                        }
                        .fullScreenCover(isPresented: $isVideoCameraViewVisible, onDismiss: {
                            self.isVideoCameraViewVisible = false
                        }) {
                            try? Video.camera { _ in }
                        }
                    }

                    Section {
                        Button(action: {
                            self.isLivePhotoBrowserViewVisible = true
                        }) {
                            Text("LivePhoto.browser")
                        }
                        .fullScreenCover(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                            self.isLivePhotoBrowserViewVisible = false
                        }) {
                            try? LivePhoto.browser { _ in }
                        }

                        Button(action: {
                            self.isMediaBrowserViewVisible = true
                        }) {
                            Text("Media.browser")
                        }
                        .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                            self.isMediaBrowserViewVisible = false
                        }) {
                            try? Media.browser { _ in }
                        }

                        Button(action: {
                            self.isPhotoBrowserViewVisible = true
                        }) {
                            Text("Photo.browser")
                        }
                        .fullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                            self.isPhotoBrowserViewVisible = false
                        }) {
                            try? Photo.browser { _ in }
                        }

                        Button(action: {
                            self.isVideoBrowserViewVisible = true
                        }) {
                            Text("Video.browser")
                        }
                        .fullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                            self.isVideoBrowserViewVisible = false
                        }) {
                            try? Video.browser { _ in }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Examples")
            } else {
                VStack(spacing: 20) {
                    if let permissionError = permissionError {
                        Text(permissionError.localizedDescription)
                    }

                    Button(action: requestPermission) {
                        Text("Trigger permission request")
                    }
                }
            }
        }.onAppear {
            if !Media.isAccessAllowed {
                requestPermission()
            } else {
                userAlbums = Albums.user
                cloudAlbums = Albums.cloud
                smartAlbums = Albums.smart
            }
        }
    }
}

private extension RootScreen {
    func requestPermission() {
        Media.requestPermission { result in
            switch result {
            case .success:
                permissionGranted = true
                permissionError = nil
                userAlbums = Albums.user
                cloudAlbums = Albums.cloud
                smartAlbums = Albums.smart
            case .failure(let error):
                permissionGranted = false
                permissionError = error
            }
        }
    }
}

#if DEBUG
struct AlbumsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
#endif
