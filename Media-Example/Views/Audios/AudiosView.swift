//
//  AudiosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AudiosView: View {
    let audios: [Audio]

    var body: some View {
        List(audios) { audio in
            Text(audio.id)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Audios", displayMode: .inline)
    }
}

#if DEBUG
struct AudiosView_Previews: PreviewProvider {
    static var previews: some View {
        AudiosView(audios: [])
    }
}
#endif
