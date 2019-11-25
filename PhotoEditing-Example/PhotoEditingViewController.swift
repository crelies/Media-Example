//
//  PhotoEditingViewController.swift
//  PhotoEditing-Example
//
//  Created by Christian Elies on 24.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

final class PhotoEditingViewController: UIViewController, PHContentEditingController {
    @IBOutlet private weak var imageView: UIImageView!

    private var displayedImage: UIImage?
    private var imageOrientation: Int32?
    private var input: PHContentEditingInput?
    private var currentFilter = "CIColorInvert"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - PHContentEditingController

    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }

    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        input = contentEditingInput

        if let input = input {
            displayedImage = input.displaySizeImage
            imageOrientation = input.fullSizeImageOrientation
            imageView.image = displayedImage
        }
    }

    func finishContentEditing(completionHandler: @escaping ((PHContentEditingOutput?) -> Void)) {
        guard let input = input else {
            completionHandler(nil)
            return
        }

        // Update UI to reflect that editing has finished and output is being rendered.

        // Render and provide output on a background queue.
        DispatchQueue.global().async {
            // Create editing output from the editing input.
            let output = PHContentEditingOutput(contentEditingInput: input)
            let url = input.fullSizeImageURL

            do {
                if let imageURL = url {
                    let fullImage = UIImage(contentsOfFile: imageURL.path)

                    if let renderedJPEGData = UIImage().jpegData(compressionQuality: 0.9) {
                        try renderedJPEGData.write(to: output.renderedContentURL)
                    }

                    let archivedData = NSKeyedArchiver.archivedData(withRootObject: self.currentFilter)

                    let adjustmentData = PHAdjustmentData(formatIdentifier: "com.ebookfrenzy.photoext",
                                                          formatVersion: "1.0",
                                                          data: archivedData)
                    output.adjustmentData = adjustmentData
                }
            } catch {
                
            }

            // Provide new adjustments and render output to given location.
            // output.adjustmentData = <#new adjustment data#>
            // let renderedJPEGData = <#output JPEG#>
            // renderedJPEGData.writeToURL(output.renderedContentURL, atomically: true)
            
            // Call completion handler to commit edit to Photos.
            completionHandler(output)

            // Clean up temporary files, etc.
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }
}
