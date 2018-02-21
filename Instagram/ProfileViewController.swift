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
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.layer.cornerRadius = 4
            editButton.layer.borderWidth = 1.5
            editButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var ref : DatabaseReference!
    
    var images : [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadDetails()
        
        observeImageURL()
        
    }
    
    func observeImageURL() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userID = user.uid
            print(userID)
            
            ref.child("users").child(userID).child("images").observe(.childAdded, with: { (snapshot) in
                
                if let value = snapshot.value as? String {
                    let image = Image(imageUID: snapshot.key, imageURL: value)
                    
                    DispatchQueue.main.async {
                        self.collectionView.performBatchUpdates({
                            self.images.append(image)
                            let indexPath = IndexPath(row: self.images.count - 1, section: 0)
                            self.collectionView.insertItems(at: [indexPath])
                        }, completion: nil)
                    }
                }
            })
        }
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
            
            ref.child("users").child(userID).child("images").observe(.value, with: { (snapshot) in
                
                let imagesCount = snapshot.childrenCount
                
                print("Images Count: \(imagesCount)")
                
                self.postNumberLabel.text = "\(imagesCount)"
                
                
            })
            
            ref.child("follower").child(userID).observe(.value, with: { (snapshot) in
                
                let followerCount = snapshot.childrenCount
                
                print("Follower Count: \(followerCount)")
                
                self.followerNumberLabel.text = "\(followerCount)"
                
            })
            
            ref.child("following").child(userID).observe(.value, with: { (snapshot) in
                
                let followingCount = snapshot.childrenCount
                
                print("Follower Count: \(followingCount)")
                
                self.followingNumberLabel.text = "\(followingCount)"
                
            })
            
        }
        
        
        
        
        
        
    }
    
}

extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        
        if let imageViewForCell = cell.profileImageView {

            let picURL = images[indexPath.row].imageURL

            getImage(picURL, imageViewForCell)
        }

        return cell
    }
}

