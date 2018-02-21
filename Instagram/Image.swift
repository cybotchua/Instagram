//
//  Image.swift
//  Instagram
//
//  Created by Terence Chua on 20/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation

class Image {
    static var InstaDateFormater : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter
    }
    var imageUID : String = ""
    var comments : String = ""
    var uploaderUID : String = ""
    var imageURL : String = ""
    var caption : String = ""
    var timeStamp : NSNumber = 0
    var user : User!
    
    
    var timeStampString : String {
        let date = Date(timeIntervalSince1970: timeStamp.doubleValue)
        return Image.InstaDateFormater.string(from: date)
    }
    
    init(imageUID: String, imageURL: String) {
        self.imageUID = imageUID
        self.imageURL = imageURL
    }

    init(imageUID: String, imageDict: [String : Any]) {
        self.imageUID = imageUID
        self.comments = imageDict["comments"] as? String ?? "No comments"
        self.uploaderUID = imageDict["uploaderUID"] as? String ?? "No uploaderUID"
        self.imageURL = imageDict["imageURL"] as? String ?? "No URL"
        caption = imageDict["caption"] as? String ?? "No caption"
        timeStamp = imageDict["timeStamp"] as? NSNumber ?? 0
    }
    
}
