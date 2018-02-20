//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

/*
Profile Page
    - Edit Profile
        - See other profile (follow / unfollow)
            - * Delete Account
*/
 
 
 
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var postNumberLabel: UILabel!
    
    @IBOutlet weak var followerNumberLabel: UILabel!
    
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
