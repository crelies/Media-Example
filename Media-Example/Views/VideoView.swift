//
//  VideoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AVFoundation
import Media
import SwiftUI

struct VideoView: View {
    let video: Video

    @State private var avPlayerItem: AVPlayerItem?
    @State private var error: Error?

    var body: some View {
        Group {
            avPlayerItem.map { AVPlayerView(avPlayerItem: $0) }

            error.map { Text($0.localizedDescription) }
        }.onAppear {
            self.video.playerItem { result in
                switch result {
                case .success(let avPlayerItem):
                    self.avPlayerItem = avPlayerItem
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
