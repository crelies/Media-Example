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

    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: true)])
    private var videos: [Video]

    @FetchAlbums(ofType: .smart)
    private var albums: [Album]

    var body: some View {
        NavigationView {
            if permissionGranted || Media.isAccessAllowed {
                List {
                    Section {
                        // TODO:
//                        NavigationLink(destination: VideosView(videos: videos)) {
//                            Text("@FetchAssets videos")
//                        }
                        
                        // TODO:
//                        NavigationLink(destination: AlbumsView(albums: albums)) {
//                            Text("@FetchAlbums smart")
//                        }
                    }

                    Section {
                        if let userAlbums = userAlbums {
                            NavigationLink(destination: AlbumsView(albums: userAlbums)) {
                                Text("User albums (\(userAlbums.count))")
                            }

                            let item = Item.albums(albums: userAlbums)
                            NavigationLink(destination: ScrollView {
                                LazyTree(node: item, children: \.children)
                            }) {
                                Text("Lazy Tree")
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

                    PhotosSection()

                    VideosSection()

                    CameraSection()

                    BrowserSection()
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
