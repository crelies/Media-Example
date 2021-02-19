//
//  PhotoGridView.swift
//  Media-Example
//
//  Created by Christian Elies on 14.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotoGridView: View {
    let photos: [Photo]

    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(photos) { photo in
                    photo.view(targetSize: .init(width: 200, height: 200)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            })
        }
    }
}

#if DEBUG
struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView(photos: [])
    }
}
#endif
