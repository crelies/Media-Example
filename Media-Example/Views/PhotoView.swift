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
    @State private var isErrorAlertVisible = false
    @State private var isFavorite = false

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

        return VStack(spacing: 16) {
            photo.view { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Text(photo.subtypes.map { String(describing: $0) }.joined(separator: ", "))
        }.onAppear {
            self.isFavorite = self.photo.metadata.isFavorite
        }.navigationBarItems(trailing: HStack {
            Button(action: {
                self.photo.favorite(!self.photo.metadata.isFavorite) { result in
                    switch result {
                    case .success:
                        self.isFavorite = !self.photo.metadata.isFavorite
                    case .failure(let error):
                        self.error = error
                        self.isErrorAlertVisible = true
                    }
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }.alert(isPresented: $isErrorAlertVisible) { self.errorAlert(error) }

            Button(action: {
                self.isShareSheetVisible = true
            }) {
                Text("Share")
            }.sheet(isPresented: $isShareSheetVisible, onDismiss: {
                self.isShareSheetVisible = false
            }) {
                self.data.map { UIImage(data: $0).map { ActivityView(activityItems: [$0], applicationActivities: []) } }
            }
        })
    }
}

extension PhotoView {
    private func errorAlert(_ error: Error?) -> Alert {
        Alert(title: Text("Error"), message: Text(error?.localizedDescription ?? "An unknown error occurred"), dismissButton: .cancel {
            self.isErrorAlertVisible = false
        })
    }
}
