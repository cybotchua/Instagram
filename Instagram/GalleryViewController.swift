//
//  GalleryViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import YPImagePicker

class GalleryViewController: UIViewController {
    
    var ref: DatabaseReference!
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fusumaFunction()
    }
    
    func fusumaFunction () {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromLibrary = false
        config.onlySquareImagesFromCamera = true
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = true
//        config.videoCompression = AVAssetExportPresetHighestQuality
        config.albumName = "MyGreatAppName"
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.videoRecordingTimeLimit = 10
        config.videoFromLibraryTimeLimit = 20
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        
        picker.didSelectImage = { [unowned picker] img in
            // image picked
            print(img.size)
//            self.imageView.image = img
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
            
            vc.image = img
        
            picker.present(vc, animated: true, completion: nil)
//            picker.dismiss(animated: true, completion: nil)
            
        }
        picker.didSelectVideo = { videoData, videoThumbnailImage, URL in
            // video picked
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
            vc.image = videoThumbnailImage
            
//            self.imageView.image = videoThumbnailImage
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
}

//extension GalleryViewController: FusumaDelegate {
//    func fusumaVideoCompleted(withFileURL fileURL: URL) {
//        print("Called just after a video has been selected.")
//
//    }
//
//    // Return the image which is selected from camera roll or is taken via the camera.
//    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
//
//        print("Image selected")
//    }
//
//    // Return the image but called after is dismissed.
//    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
//
//        print("Called just after FusumaViewController is dismissed.")
//    }
//
//    // When camera roll is not authorized, this method is called.
//    func fusumaCameraRollUnauthorized() {
//
//        print("Camera roll unauthorized")
//    }
//
//    // Return selected images when you allow to select multiple photos.
//    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
//        print("testing")
//    }

//    // Return an image and the detailed information.
//    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
//        print("Oh my god")
//    }
//}

