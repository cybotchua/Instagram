//
//  PostViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 21/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBAction func postButtonTapped(_ sender: Any) {
        uploadPost()
    }
    
    var image : UIImage = UIImage(named: "") ?? UIImage()
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        ref = Database.database().reference()
    } //end of ViewDidLoad
    
    func uploadToStorage(_ image: UIImage, _ imagePostUID : String) {
        //create storage reference or location
        let storageRef = Storage.storage().reference()

        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        //storage reference
        storageRef.child(uid).child(imagePostUID).putData(imageData, metadata: metaData) { (meta, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            //handle successful case with metadata returned
            //metadata contains details on the file uploaded on storage
            //we checking if a downloadURL exists
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("images").child(imagePostUID).child("imageURL").setValue(downloadURL)
                // users >> currentUserUID >> images
                self.ref.child("users").child(uid).child("images").child(imagePostUID).setValue(downloadURL)
            }
        }
    } //end of func UploadToStorage
    
    func uploadPost() {
        guard let caption = captionTextField.text else {return}
        guard let email = Auth.auth().currentUser?.email else {return}
        let timeStamp = Date().timeIntervalSince1970
        let ref = self.ref.child("images").childByAutoId()
        
        //UPLOAD IMAGE TO STORAGE
        //upload profileImage to storage
        if let image = self.imageView.image {
            self.uploadToStorage(image, ref.key)
        }
        let userPost: [String:Any] = ["email": email, "caption" : caption, "timeStamp" : timeStamp]

        ref.setValue(userPost)
                
        let storyBoard = UIStoryboard(name: "DetailsStoryboard", bundle: Bundle.main)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "navigationController") as? UITabBarController else {return}
        self.present(vc, animated: false, completion: nil)

    } // END OF uploadPost
    
} //end of Class
