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
    @State private var userAlbums: LazyAlbums?
    @State private var cloudAlbums: LazyAlbums?
    @State private var smartAlbums: LazyAlbums?

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
//                        NavigationLink(destination: VideosView(videos: videos)) {
//                            Text("@FetchAssets videos")
//                        }
//                        NavigationLink(destination: AlbumsView(albums: albums)) {
//                            Text("@FetchAlbums smart")
//                        }
                    }

                    Section {
                        if let userAlbums = userAlbums {
                            NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                                Text("User albums (\(userAlbums.count))")
                            }
                        }

                        if let cloudAlbums = cloudAlbums {
                            NavigationLink(destination: AlbumsView(albums: cloudAlbums)) {
                                Text("Cloud albums (\(cloudAlbums.count))")
                            }
                        }

                        if let smartAlbums = smartAlbums {
                            NavigationLink(destination: AlbumsView(albums: smartAlbums)) {
                                Text("Smart albums (\(smartAlbums.count))")
                            }
                        }
                    }

                    if let audios = LazyAudios.all {
                        Section {
                            NavigationLink(destination: AudiosView(audios: audios)) {
                                Text("Audios.all (\(audios.count))")
                            }
                        }
                    }

                    Section {
                        if let allPhotos = Media.LazyPhotos.all {
                            NavigationLink(destination: PhotosView(photos: allPhotos)) {
                                Text("Media.Photos.all (\(allPhotos.count))")
                            }
                        }

                        if let livePhotos = Media.LazyPhotos.live {
                            NavigationLink(destination: LivePhotosView(livePhotos: livePhotos)) {
                                Text("Media.Photos.live (\(livePhotos.count))")
                            }
                        }

                        if let depthEffectPhotos = Media.LazyPhotos.depthEffect {
                            NavigationLink(destination: PhotosView(photos: depthEffectPhotos)) {
                                Text("Photos.depthEffect (\(depthEffectPhotos.count))")
                            }
                        }

                        if let hdrPhotos = Media.LazyPhotos.hdr {
                            NavigationLink(destination: PhotosView(photos: hdrPhotos)) {
                                Text("Photos.hdr (\(hdrPhotos.count))")
                            }
                        }

                        if let panoramaPhotos = Media.LazyPhotos.panorama {
                            NavigationLink(destination: PhotosView(photos: panoramaPhotos)) {
                                Text("Photos.panorama (\(panoramaPhotos.count))")
                            }
                        }

                        if let screenshotPhotos = Media.LazyPhotos.screenshot {
                            NavigationLink(destination: PhotosView(photos: screenshotPhotos)) {
                                Text("Photos.screenshot (\(screenshotPhotos.count))")
                            }
                        }
                    }

                    Section {
                        if let allVideos = LazyVideos.all {
                            NavigationLink(destination: VideosView(videos: allVideos)) {
                                Text("Videos.all (\(allVideos.count))")
                            }
                        }

                        if let highFrameRatesVideos = LazyVideos.highFrameRates {
                            NavigationLink(destination: VideosView(videos: highFrameRatesVideos)) {
                                Text("Videos.highFrameRates (\(highFrameRatesVideos.count))")
                            }
                        }

                        if let streamsVideos = LazyVideos.streams {
                            NavigationLink(destination: VideosView(videos: streamsVideos)) {
                                Text("Videos.streams (\(streamsVideos.count))")
                            }
                        }

                        if let timelapsesVideos = LazyVideos.timelapses {
                            NavigationLink(destination: VideosView(videos: timelapsesVideos)) {
                                Text("Videos.timelapses (\(timelapsesVideos.count))")
                            }
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
                userAlbums = LazyAlbums.user
                cloudAlbums = LazyAlbums.cloud
                smartAlbums = LazyAlbums.smart
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
                userAlbums = LazyAlbums.user
                cloudAlbums = LazyAlbums.cloud
                smartAlbums = LazyAlbums.smart
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
