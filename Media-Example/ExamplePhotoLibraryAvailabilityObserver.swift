//
//  ExamplePhotoLibraryAvailabilityObserver.swift
//  Media-Example
//
//  Created by Christian Elies on 15.01.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Photos

final class ExamplePhotoLibraryAvailabilityObserver: NSObject, PHPhotoLibraryAvailabilityObserver {
    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        debugPrint("photo library did become unvailable")
    }
}
