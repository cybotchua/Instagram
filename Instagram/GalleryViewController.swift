//
//  GalleryViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import Fusuma

class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fusumaFunction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fusumaFunction()
    }
    
    func fusumaFunction () {
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
//        fusuma.hasVideo = true //To allow for video capturing with .library and .camera available by default
        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        
        fusumaCameraRollTitle = "Gallery"
        fusumaCameraTitle = "Photo" // Camera Title
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
}

extension GalleryViewController: FusumaDelegate {
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")

    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    // Return selected images when you allow to select multiple photos.
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("testing")
    }
    
//    // Return an image and the detailed information.
//    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
//        print("Oh my god")
//    }
}
