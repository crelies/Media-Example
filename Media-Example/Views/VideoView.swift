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
    @State private var exportSuccessful = false

    let video: Video

    var body: some View {
        video.view
            .navigationBarItems(trailing: Button(action: {
                guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }

                let fileURL = url.appendingPathComponent("\(UUID().uuidString)")
                guard let exportDestination = try? Video.ExportDestination(url: fileURL, fileType: .mobile3GPP2) else {
                    return
                }

                self.exportSuccessful = false
                self.video.export(to: exportDestination, quality: .low) { result in
                    switch result {
                    case .success:
                        self.exportSuccessful = true
                    case .failure:
                        self.exportSuccessful = false
                    }
                }
            }) {
                Text("Export")
                    .foregroundColor(exportSuccessful ? Color(.systemGreen) : Color(.systemBlue))
            })
    }
}
