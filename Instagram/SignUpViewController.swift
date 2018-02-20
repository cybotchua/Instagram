//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Terence Chua on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import Pastel
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLoginBackground()

        ref = Database.database().reference()
    }
    
    //Function to Sign Up New User
    @objc func signUpUser() {
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        //Input Validation
        if !email.contains("@") {
            showAlert(withTitle: "Invalid Email Format", message: "Please input a valid email")
        } else if username.count < 3 {
            showAlert(withTitle: "Invalid Username", message: "Username must contain at least 3 characters")
        } else if password.count < 7 {
            showAlert(withTitle: "Invalid Password", message: "Password must be at least 7 characters long")
        } else if confirmPassword != password {
            showAlert(withTitle: "Passwords Do Not Match", message: "Please enter the same passwords")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                //Error
                if let validError = error {
                    self.showAlert(withTitle: "ERROR", message: validError.localizedDescription)
                }
                
                
                //Successful Creation of New User
                if let validUser = user {
                    
                    if let image = self.imageView.image {
                        self.uploadToStorage(image)
                    }
                    
                    let newUser : [String : Any] = ["email" : email, "username" : username]
                    
                    self.ref.child("users").child(validUser.uid).setValue(newUser)
                    
                    let sb = UIStoryboard(name: "DetailsStoryboard", bundle: Bundle.main)
                    
                    guard let vc = sb.instantiateViewController(withIdentifier: "navigationController") as? UITabBarController else {return}
                    
                    self.navigationController?.popViewController(animated: false)
                    
                    self.present(vc, animated: false, completion: nil)
                }
            })
        }
    }
    
    @objc func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadToStorage(_ image: UIImage) {
        let storageRef = Storage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        storageRef.child(uid).child("profilePic").putData(imageData, metadata: metaData) { (meta, error) in
            
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("users").child(uid).child("profilePicURL").setValue(downloadURL)
            }
        }
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        imageView.image = image
        
    }
    
}
