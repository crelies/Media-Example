//
//  AVPlayerView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AVFoundation
import AVKit
import SwiftUI

struct AVPlayerView: UIViewControllerRepresentable {
    let avPlayerItem: AVPlayerItem

    func makeUIViewController(context: UIViewControllerRepresentableContext<AVPlayerView>) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        let player = AVPlayer(playerItem: avPlayerItem)
        viewController.player = player
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<AVPlayerView>) {

    }
}
