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
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var postNumberLabel: UILabel!
    
    @IBOutlet weak var followerNumberLabel: UILabel!
    
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        loadDetails()
        
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
    
    func loadDetails() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userID = user.uid
            print(userID)
        
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? [String : Any],
                    let username = value["username"] as? String,
                    let profilePicURL = value["profilePicURL"] as? String {
                    
                    self.nameLabel.text = username
                    self.getImage(profilePicURL, self.profileImageView)
                    
                }
                
            })
            
            ref.child("follower").child(userID).observe(.value, with: { (snapshot) in
                
                let followerCount = snapshot.childrenCount
                
                print(followerCount)
                
                self.followerNumberLabel.text = "\(followerCount)"
                
            })
        
        }
        
        
        
        
        
        
    }
    
}
