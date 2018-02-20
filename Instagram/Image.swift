//
//  Image.swift
//  Instagram
//
//  Created by Terence Chua on 20/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation

class Image {
    var imageUID : String = ""
    var comments : String = ""
    var uploaderUID : String = ""
    var imageURL : String = ""
    
    init(imageUID: String, imageDict: [String : Any]) {
        self.imageUID = imageUID
        self.comments = imageDict["comments"] as? String ?? "No comments"
        self.uploaderUID = imageDict["uploaderUID"] as? String ?? "No uploaderUID"
        self.imageURL = imageDict["imageURL"] as? String ?? "No URL"
    }
    
}
