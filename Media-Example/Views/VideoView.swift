//
//  VideoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AVFoundation
import MediaCore
import SwiftUI
import UIKit

private struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct VideoView: View {
    private enum PreviewImageState {
        case loading
        case loaded(image: UniversalImage)
    }

    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()

    @State private var previewImageState: PreviewImageState = .loading
    @State private var exportSuccessful: Bool?
    @State private var progress: Float = 0

    let video: Video

    var body: some View {
        VStack(spacing: 16) {
            switch previewImageState {
            case .loading:
                ActivityIndicatorView()
                    .onAppear {
                        video.previewImage { result in
                            guard let previewImage = try? result.get() else {
                                return
                            }
                            previewImageState = .loaded(image: previewImage)
                        }
                    }
            case let .loaded(previewImage):
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            video.view
                .navigationBarItems(trailing: VStack(spacing: 8) {
                    Button(action: export) {
                        Text("Export")
                            .foregroundColor(exportSuccessful == nil ? Color(.systemBlue) : ((exportSuccessful ?? true) ? Color(.systemGreen) : Color(.systemRed)))
                    }

                    if progress > 0 {
                        ProgressView(value: progress, total: 1)
                    }
                })

            if let videoSubtypes = video.subtypes {
                Text(videoSubtypes.map { String(describing: $0) }.joined(separator: ", "))
            }
        }
    }
}

private extension VideoView {
    func export() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileURL = url.appendingPathComponent("\(UUID().uuidString).mov")
        guard let outputURL = try? Media.URL<Video>(url: fileURL) else {
            return
        }

        let exportOptions = Video.ExportOptions(url: outputURL, quality: .low)

        exportSuccessful = nil
        progress = 0
        video.export(exportOptions, progress: { progress in
            switch progress {
            case .completed:
                self.progress = 0
            case .pending(let value):
                self.progress = value
            }
        }) { result in
            switch result {
            case .success:
                progress = 0
                exportSuccessful = true
            case .failure:
                progress = 0
                exportSuccessful = false
            }
        }
    }
}
