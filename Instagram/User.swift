//
//  User.swift
//  Instagram
//
//  Created by Terence Chua on 20/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import Foundation

class User {
    var uid : String = ""
    var email : String = ""
    var username : String = ""
    var profilePicURL : String = ""
    
    init(uid: String, userDict: [String : Any]){
        self.uid = uid
        self.email = userDict["email"] as? String ?? "No email"
        self.username = userDict["username"] as? String ?? "No username"
        self.profilePicURL = userDict["profilePicURL"] as? String ?? "No URL"
    }
    
}
