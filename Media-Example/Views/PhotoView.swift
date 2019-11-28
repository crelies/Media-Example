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
    @State private var error: Error?
    @State private var isShareSheetVisible = false

    var body: some View {
        if data == nil && error == nil {
            photo.data { result in
                switch result {
                case .success(let data):
                    self.data = data
                case .failure(let error):
                    self.error = error
                }
            }
        }

        return Group {
            photo.view { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }.navigationBarItems(trailing: Button(action: {
            self.isShareSheetVisible = true
        }) {
            Text("Share")
        }.sheet(isPresented: $isShareSheetVisible, onDismiss: {
            self.isShareSheetVisible = false
        }) {
            self.data.map { UIImage(data: $0).map { ActivityView(activityItems: [$0], applicationActivities: []) } }
        })
    }
}
