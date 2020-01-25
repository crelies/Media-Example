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
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()

    @State private var exportSuccessful: Bool?
    @State private var progress: Float = 0

    let video: Video

    var body: some View {
        VStack(spacing: 16) {
            video.view
                .navigationBarItems(leading: Group {
                    if progress != 0 {
                        Text("\(NSNumber(value: progress), formatter: Self.numberFormatter)")
                    }
                }, trailing: Button(action: {
                    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        return
                    }

                    let fileURL = url.appendingPathComponent("\(UUID().uuidString).mov")
                    guard let outputURL = try? Media.URL<Video>(url: fileURL) else {
                        return
                    }

                    let exportOptions = Video.ExportOptions(url: outputURL, quality: .low)

                    self.exportSuccessful = nil
                    self.progress = 0
                    self.video.export(exportOptions, progress: { progress in
                        switch progress {
                        case .completed:
                            self.progress = 0
                        case .pending(let value):
                            self.progress = value
                        }
                    }) { result in
                        switch result {
                        case .success:
                            self.progress = 0
                            self.exportSuccessful = true
                        case .failure:
                            self.progress = 0
                            self.exportSuccessful = false
                        }
                    }
                }) {
                    Text("Export")
                        .foregroundColor(exportSuccessful == nil ? Color(.systemBlue) : ((exportSuccessful ?? true) ? Color(.systemGreen) : Color(.systemRed)))
                })

            Text(video.subtypes.compactMap {$0 }.map { String(describing: $0) }.joined(separator: ", "))
        }
    }
}
