//
//  PhotoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Media
import SwiftUI

struct PhotoView: View {
    let photo: Photo

    @State private var data: Data?
    @State private var image: UIImage?
    @State private var error: Error?

    var body: some View {
        Group {
            data.map { UIImage(data: $0).map { Image(uiImage: $0).resizable().aspectRatio(contentMode: .fit) } }

            error.map { Text($0.localizedDescription) }
        }.onAppear {
            self.photo.data { result in
                switch result {
                case .success(let data):
                    self.data = data
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
}
