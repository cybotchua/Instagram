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
    var timeStamp : NSNumber = 0
    var currentTimeStamp = NSDate()

    init(imageUID: String, imageDict: [String : Any]) {
        self.imageUID = imageUID
        self.comments = imageDict["comments"] as? String ?? "No comments"
        self.uploaderUID = imageDict["uploaderUID"] as? String ?? "No uploaderUID"
        self.imageURL = imageDict["imageURL"] as? String ?? "No URL"
        timeStamp = imageDict["timeStamp"] as? NSNumber ?? 0

        let seconds = timeStamp.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
    }
    
}
