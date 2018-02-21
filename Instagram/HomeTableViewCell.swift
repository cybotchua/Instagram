//
//  HomeTableViewCell.swift
//  Instagram
//
//  Created by Lih Heng Yew on 20/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

protocol HomeTableViewCellDelegate {
    func didLike(at indexPath: IndexPath)
}


class HomeTableViewCell: UITableViewCell {

    
    var index = IndexPath()
    
    @IBOutlet weak var uploaderImage: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var UploaderLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    var ref : DatabaseReference!
    var delegate : HomeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        homeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestures))
        tapGesture.numberOfTapsRequired = 2
        homeImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestures() {
        likesAdding()
        print("hell ya yohohoho")
    }
    
    func likesAdding() {
        delegate?.didLike(at: index)
//        let imageUID = self.ref.child("images")
//
//        let user = Auth.auth().currentUser
//        let userPost: [String:Any] = ["users": user]
//
//        self.ref.child("likes").child("imagUID").child("users").setValue(userPost)
        
    } // END OF signUpUser
    
}

//Delegate :
//extension HomeTableViewCell : UIGestureRecognizerDelegate {
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}

